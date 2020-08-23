module TestInterface
    using Test
    using CBSOData3

    include("mock_getodata.jl")
    
    tbl = CBSOData3.ODataTable("80137ned")
    @test length(tbl) == 675
end
