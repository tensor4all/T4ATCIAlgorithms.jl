using Aqua
import T4ATCIAlgorithms as TCIA

@testset "Aqua" begin
    Aqua.test_all(TCIA; ambiguities = false, unbound_args = false, deps_compat = false)
end
