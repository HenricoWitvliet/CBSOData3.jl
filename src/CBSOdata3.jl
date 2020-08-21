module CBSOData3

import HTTP
import JSON
import Tables

export get_tables, get_meta, OdataTable

BASE_URL = "http://opendata.cbs.nl"
API = "ODataFeed/odata"
CATALOG = "ODataCatalog"


function get_odata(url)
    result = HTTP.get(url)
    data = JSON.parse(String(result.body))
end


"""
    get_tables(base, catalog)

Get all the tables in the catalog as a list of dicts. The `Identifier` can be 
used to get the actual data. If no parameters are given, the data is retrieved
from the (CBS)[https://www.cbs.nl] OData3 portal.

The optional parameters are:

  - base::String, basename of the OData3 server
  - catalog::String, path part of the OData3 server for catalog information

"""
function get_tables(base=BASE_URL, catalog=CATALOG)
    url = base * "/" * catalog * "/Tables?\$format=json"
    return get_odata(url)["value"]
end


"""
    get_meta(table; base, api)

Get the metadata for a given `table`. The result is a dict with the keys `"TableInfos"`, `"DataProperties"` and all the classifications.

Optional parameters are:

  - base::String, basename of the OData3 server
  - api::String, path part of the OData3 server for regular data
"""
function get_meta(table; base=BASE_URL, api=API)
    url = base * "/" * api * "/" * table * "?\$format=json"
    metalinks = get_odata(url)["value"]
    meta = Dict{String,Any}()
    for link in metalinks
        name = link["name"]
        if name in ("UntypedDataSet", "TypedDataSet")
            continue
        end
        linkurl = link["url"] * "?\$format=json"
        meta[name] = get_odata(linkurl)["value"]
    end
    return meta
end 


struct OdataTable
    table::String
    block::Vector{Any}
    nextlink::Union{Nothing, String}
    names::Vector{Symbol}
    types::Vector{Type}
    length::Int
end

function firstline(t::OdataTable)
    datablock = getfield(t, :block)
    nextlink = getfield(t, :nextlink)
    row = 1
    return (OdataRow(datablock[row], t), (datablock, nextlink, row))
end


function nextline(t::OdataTable, status)
    datablock, nextlink, row = status
    if row == length(datablock) && !isnothing(nextlink)
        datablock, nextlink = get_block(nextlink)
        row = 0
    end
    row += 1
    if row > length(datablock)
        return nothing
    else
        return (OdataRow(datablock[row], t), (datablock, nextlink, row))
    end
end


struct OdataRow <: Tables.AbstractRow
    row::Dict{String, Any}
    table::OdataTable
end

Tables.istable(::OdataTable) = true
names(t::OdataTable) = getfield(t, :names)
Tables.columnnames(t::OdataTable) = getfield(t, :names)
types(t::OdataTable) = getfield(t, :types)
Tables.schema(t::OdataTable) = Tables.Schema(names(t), types(t))

Tables.rowaccess(::OdataTable) = true
Tables.rows(t::OdataTable) = t
Base.eltype(t::OdataTable) = OdataRow
Base.length(t::OdataTable) = getfield(t, :length)
Base.iterate(t::OdataTable) = firstline(t)
Base.iterate(t::OdataTable, st) = nextline(t, st)

Tables.getcolumn(r::OdataRow, s::String) = something(getfield(r, :row)[s], missing)
Tables.getcolumn(r::OdataRow, i::Int) = something(collect(values(getfield(r, :row)))[getfield(getfield(r, :table), :names)[i]], missing)
Tables.getcolumn(r::OdataRow, s::Symbol) = something(getfield(r, :row)[String(s)], missing)

Tables.columnnames(r::OdataRow) = collect(keys(getfield(r, :row)))
Base.NamedTuple(r::OdataRow) = NamedTuple{Tuple(Symbol.(keys(getfield(r, :row))))}(values(getfield(r, :row)))

function get_block(url)
    data = get_odata(url)
    nextlink = "odata.nextLink" in keys(data) ? data["odata.nextLink"] : nothing
    return (data["value"], nextlink)
end

function get_table(table; base=BASE_URL, api=API, kind="UntypedDataSet", columns=[], filter="")
    if length(columns) == 0
        select = ""
    else
        select = "&\$select=" * join(columns, ",")
    end
    if length(filter) > 0
        filter = "&\$filter=" * HTTP.escape(filter)
    end
    url = base * "/" * api * "/" * table * "/" * kind * "/?\$format=json" * select * filter
    data = get_odata(url)
    nextlink = "odata.nextLink" in keys(data) ? data["odata.nextLink"] : nothing
    return (data["value"], nextlink)
end


"""
    ODataTable(table; typed, columns, filters, base, api, catalog)

Get a `Tables` object for the dataset defined by `table`.
Optional parameters are:

  - typed::Bool, do we want a TypedDataSet (numbers as ints or floats) or an
                 UntypedDataSet (everything string)
  - columns::Vector{String}, exact columnnames to select, empty for all columns
  - filters::String, OData3 specification for row filter
  - base::String, basename of the OData3 server
  - api::String, path part of the OData3 server for regular data
  - catalog::String, path part of the OData3 server for catalog information

# Examples
```julia
tbl = CBSOData3.ODataTable("82811NED", columns=["Perioden", "Onderzoekspopulatie_1", "Innovatoren_2"], filter="Perioden eq '2010X000'");
```
"""
function ODataTable(table; typed=true, columns=[], filter="", base=BASE_URL, api=API, catalog=CATALOG)
    kind = typed ? "TypedDataSet" : "UntypedDataSet"
    if length(filter) == 0
        tabellen = get_tables(base, catalog)
        tabelinfo = [x for x in tabellen if x["Identifier"] == table]
        if length(tabelinfo) == 1
            recordcount = tabelinfo[1]["RecordCount"]
        else
            recordcount = None
        end
        nextblock, nextlink = get_table(table, base=base, api=api, kind=kind, columns=columns)
    else
        # bij opgegeven filter alle blokken inlezen
        nextblock, nextlink = get_table(table, base=base, api=api, kind=kind, columns=columns, filter=filter)
        while !isnothing(nextlink)
            nxtblk, nextlink = get_block(nextlink)
            nextblock = vcat(nextblock, nxtblk)
        end
        recordcount = length(nextblock)
    end
    if length(columns) > 1
        names = Symbol.(columns)
    else
        meta = get_meta(table)
        names = Symbol.(collect(keys(nextblock[1])))
        dd = [Symbol(x["Key"])=>x["Position"] for x in meta["DataProperties"] if Symbol(x["Key"]) in names]
        sort!(dd, by=x->x.second)
        dd = [x.first=>nr for (nr, x) in enumerate(dd)]
        names = [x.first for x in dd]
    end
    types = [typeof(nextblock[1][String(name)]) for name in names]
    if typed
        types = [Union{Missing, x} for x in types]
    end
    return OdataTable(table, nextblock, nextlink, names, types, recordcount)
end

end # module
