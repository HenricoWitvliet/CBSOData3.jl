module TestMeta
    using Test
    using CBSOData3

    include("mock_getodata.jl")

    meta_80137ned = CBSOData3.get_meta("80137ned")
    @test "DataProperties" in keys(meta_80137ned)
    @test Set(["TableInfos", "CategoryGroups", "BedrijfstakkenSBI93", "Persoonskenmerken", "DataProperties", "Perioden"]) == Set(keys(meta_80137ned))

end
