CBSOData3
=========

This is a simple [Tables](https://github.com/JuliaData/Tables.jl)-interface to use the [CBS](https://opendata.cbs.nl/statline/portal.html?_la=nl&_catalog=CBS) odata3 portal to download all CBS-datasets.

How to use it
-------------

If you know the exact dataset, you can directly use it:
```julia
using DataFrames, CBSOdata3

df = DataFrame(CBSOdata3.OdataTable("82811NED"))
```

You can use the keyword argument `columns` to give a list of column names to select (case sensitive). And you can use `filter` to give a filter expression for the rows (as a String) using the [Odata3](https://www.odata.org/documentation/odata-version-3-0/) rules.

For a given table you can get information about the columns in the dataset and about the used classifications by using `get_meta`:
```julia
df_meta = CBSOdata3.get_meta("82811NED")
```
This gives a dict with DataProperties and the classifications.

Using `get_tables` you can get a list of dicts of all available tables. The `Identifier` can then be used to get the actual data.
