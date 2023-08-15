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

@testset "Default NPendulum system create" begin
    p = NPendulum()
    mbs = @test_nowarn create_system(p)
end

@testset "Default NPendulum system check" begin
    p = NPendulum()
    mbs = create_system(p)
    @test mbs.nq == 14
    @test mbs.nh == 12
    @test mbs.ny == 26
    @test mbs.nconstr == 11
    @test length(mbs.bodies.r_bodies) == 2
    @test length(mbs.joints) == 4
    @test length(mbs.forces) == 2
end