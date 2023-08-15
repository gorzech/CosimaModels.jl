module CosimaModels
    using Cosima
    using LinearAlgebra

    export create_system

    include("models/npendulum.jl")
    export NPendulum
end
