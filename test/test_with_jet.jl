using JET
import T4ATCIAlgorithms as TCIA

@testset "JET" begin
    if VERSION ≥ v"1.10"
        JET.test_package(TCIA; target_defined_modules=true)
    end
end

