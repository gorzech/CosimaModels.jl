@testset "Default NPendulum struct" begin
    p = @test_nowarn NPendulum()
    @test p.number_of_links == 1
    @test p.mass == 1
    @test p.length == 1
end