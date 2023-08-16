@testset "Spatial slider crank system create" begin
    p = SpatialSliderCrank()
    mbs = @test_nowarn create_system(p)
end

@testset "Spatial slider crank system check" begin
    p = SpatialSliderCrank()
    mbs = create_system(p)
    @test mbs.nq == 28
    @test mbs.nh == 24
    @test mbs.ny == 52
    @test mbs.nconstr == 23
    @test length(mbs.bodies.r_bodies) == 4
    @test length(mbs.joints) == 11
    @test length(mbs.forces) == 2
end