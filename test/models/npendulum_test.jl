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

@testset "NPendulum with 4 links system check" begin
    p = NPendulum(4)
    mbs = create_system(p)
    @test mbs.nq == 5 * 7
    @test mbs.nh == 5 * 6
    @test mbs.ny == 5 * 13
    @test mbs.nconstr == 6 + 5 * 4
    @test length(mbs.bodies.r_bodies) == 5
    @test length(mbs.joints) == 1 + 3 * 4
    @test length(mbs.forces) == 2
end

@testset "Default NPendulum system mass" begin
    p = NPendulum()
    mbs = create_system(p)
    M = mass(mbs)
    Ic = 1 / 12
    @test M ≈ diagm([ones(9); 1e-3 * Ic; Ic; Ic])
end

@testset "Default NPendulum system constraints" begin
    p = NPendulum()
    mbs = create_system(p)
    C, _, _, _ = constraints(mbs)
    @test all(C .≈ 0)
end

@testset "NPendulum system with 6 links constraints" begin
    p = NPendulum(6, 0.2, 0.7)
    mbs = create_system(p)
    C, _, _, _ = constraints(mbs)
    @test all(C .≈ 0)
end