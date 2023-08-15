module CosimaModels
    using Cosima

    export create_system

    include("models/npendulum.jl")
    export NPendulum
end
