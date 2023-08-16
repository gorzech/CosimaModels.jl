module CosimaModels
    using Cosima
    using LinearAlgebra
    using StaticArrays

    export create_system

    include("models/npendulum.jl")
    export NPendulum
    include("models/spatial_slider_crank.jl")
    export SpatialSliderCrank
end
