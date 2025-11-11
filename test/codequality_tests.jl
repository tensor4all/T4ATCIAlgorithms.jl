using Test
using Aqua
using JET
using T4ATCIAlgorithms

@testset "Aqua.jl" begin
    Aqua.test_all(T4ATCIAlgorithms; deps_compat=false)
end

#=
@testset "JET.jl" begin
    JET.test_package(T4ATCIAlgorithms; target_defined_modules=true)
end
=#
