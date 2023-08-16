using CosimaModels
using Cosima
using LinearAlgebra
using Test

@testset "CosimaModels.jl" begin
    include("models/npendulum_test.jl")
    include("models/spatial_slider_crank_test.jl")
end
