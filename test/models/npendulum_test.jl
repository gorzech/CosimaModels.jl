@testset "Default NPendulum struct" begin
    p = @test_nowarn NPendulum()
    @test p.number_of_links == 1
    @test p.mass == 1
    @test p.length == 1
end

@testset "NPendulum struct for 3 links" begin
    p = @test_nowarn NPendulum(3)
    @test p.number_of_links == 3
    @test p.mass == 1
    @test p.length == 1
end

@testset "Default NPendulum system" begin
    p = NPendulum()
    mbs = @test_nowarn create_system(p)
end