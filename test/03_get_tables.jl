module TestInterface
    using Test
    using CBSOData3

    include("mock_getodata.jl")

    tbls = CBSOData3.get_tables()
    @test length(tbls) > 0

end
