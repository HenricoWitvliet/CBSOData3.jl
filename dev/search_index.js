var documenterSearchIndex = {"docs":
[{"location":"#CBSOData3.jl","page":"CBSOData3.jl","title":"CBSOData3.jl","text":"","category":"section"},{"location":"","page":"CBSOData3.jl","title":"CBSOData3.jl","text":"Documentation for CBSOData3.jl","category":"page"},{"location":"","page":"CBSOData3.jl","title":"CBSOData3.jl","text":"Modules = [CBSOData3]\nOrder   = [:type, :function]","category":"page"},{"location":"#CBSOData3.ODataTable-Tuple{Any}","page":"CBSOData3.jl","title":"CBSOData3.ODataTable","text":"ODataTable(table; typed, columns, filters, base, api, catalog)\n\nGet a Tables object for the dataset defined by table. Optional parameters are:\n\ntyped::Bool, do we want a TypedDataSet (numbers as ints or floats) or an              UntypedDataSet (everything string)\ncolumns::Vector{String}, exact columnnames to select, empty for all columns\nfilters::String, OData3 specification for row filter\nbase::String, basename of the OData3 server\napi::String, path part of the OData3 server for regular data\ncatalog::String, path part of the OData3 server for catalog information\n\nExamples\n\ntbl = CBSOData3.ODataTable(\"82811NED\", columns=[\"Perioden\", \"Onderzoekspopulatie_1\", \"Innovatoren_2\"], filter=\"Perioden eq '2010X000'\");\n\n\n\n\n\n","category":"method"},{"location":"#CBSOData3.get_meta-Tuple{Any}","page":"CBSOData3.jl","title":"CBSOData3.get_meta","text":"get_meta(table; base, api)\n\nGet the metadata for a given table. The result is a dict with the keys \"TableInfos\", \"DataProperties\" and all the classifications.\n\nOptional parameters are:\n\nbase::String, basename of the OData3 server\napi::String, path part of the OData3 server for regular data\n\n\n\n\n\n","category":"method"},{"location":"#CBSOData3.get_tables","page":"CBSOData3.jl","title":"CBSOData3.get_tables","text":"get_tables(base, catalog)\n\nGet all the tables in the catalog as a list of dicts. The Identifier can be  used to get the actual data. If no parameters are given, the data is retrieved from the (CBS)[https://www.cbs.nl] OData3 portal.\n\nThe optional parameters are:\n\nbase::String, basename of the OData3 server\ncatalog::String, path part of the OData3 server for catalog information\n\n\n\n\n\n","category":"function"}]
}
