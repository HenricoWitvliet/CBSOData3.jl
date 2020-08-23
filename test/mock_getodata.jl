using JSON

# replace get_odata for testing
function CBSOData3.get_odata(url)
    if url == "http://opendata.cbs.nl/ODataFeed/odata/80137ned?\$format=json"
        content = JSON.parse(String(open("meta_1.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/TableInfos?\$format=json"
        content = JSON.parse(String(open("meta_2.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/CategoryGroups?\$format=json"
        content = JSON.parse(String(open("meta_3.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/Persoonskenmerken?\$format=json"
        content = JSON.parse(String(open("meta_4.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/BedrijfstakkenSBI93?\$format=json"
        content = JSON.parse(String(open("meta_5.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/Perioden?\$format=json"
        content = JSON.parse(String(open("meta_6.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/odata/80137ned/DataProperties?\$format=json"
        content = JSON.parse(String(open("meta_7.json") do io read(io) end))
        return content
    elseif url == "http://opendata.cbs.nl/ODataFeed/odata/80137ned/TypedDataSet/?\$format=json"
        content = JSON.parse(String(open("meta_8.json") do io read(io) end))
        return content
    elseif url == "http://opendata.cbs.nl/ODataCatalog/Tables?\$format=json"
        content = JSON.parse(String(open("tables_1.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/OData/83599NED/UntypedDataSet/?\$format=json"
        content = JSON.parse(String(open("tables_2.json") do io read(io) end))
        return content
    elseif url == "https://opendata.cbs.nl/ODataFeed/OData/83599NED/UntypedDataSet/?\$format=json&\$skip=10000"
        content = JSON.parse(String(open("tables_3.json") do io read(io) end))
        return content
    else
        println("Fout:" * url)
        return Dict("value"=>nothing)
    end
end
