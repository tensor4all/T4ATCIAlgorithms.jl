using Distributed

using T4ATCIAlgorithms
import T4ATCIAlgorithms as TCIA
using Random
using Test

@everywhere gaussian(x, y) = exp(-0.5 * (x^2 + y^2))
const MAX_WORKERS = 2

# Add worker processes if necessary.
if nworkers() < MAX_WORKERS
    addprocs(max(0, MAX_WORKERS - nworkers()))
end

#include("codequality_tests.jl")
# Conditionally include _util.jl if T4AITensorCompat is available
try
    include("_util.jl")
catch e
    @warn "Skipping _util.jl (T4AITensorCompat not available): $e"
end

include("util_tests.jl")
include("projector_tests.jl")
include("blockstructure_tests.jl")
# Conditionally include projectable_evaluator_tests.jl if QuanticsGrids is available
try
    include("projectable_evaluator_tests.jl")
catch e
    @warn "Skipping projectable_evaluator_tests.jl (QuanticsGrids not available): $e"
end
# Conditionally include projtensortrain_tests.jl if _util.jl was loaded (T4AITensorCompat available)
if isdefined(Main, :_test_projection)
    include("projtensortrain_tests.jl")
else
    @warn "Skipping projtensortrain_tests.jl (T4AITensorCompat not available)"
end
include("container_tests.jl")
# Conditionally include mul_tests.jl if _util.jl was loaded (T4AITensorCompat available)
if isdefined(Main, :_test_projection)
    include("mul_tests.jl")
else
    @warn "Skipping mul_tests.jl (T4AITensorCompat not available)"
end
include("distribute_tests.jl")
include("patching_tests.jl")
# Conditionally include crossinterpolate_tests.jl if QuanticsGrids is available
try
    include("crossinterpolate_tests.jl")
catch e
    @warn "Skipping crossinterpolate_tests.jl (QuanticsGrids not available): $e"
end
include("tree_tests.jl")

# This tests runs very long time, creating many patches.
#include("adaptivematmul_tests.jl")

# Following tests did not work with T4AITensorCompat
#include("itensor_compat_tests.jl")
#include("bse3d_tests.jl")

#include("crossinterpolate_lazyeval_tests.jl")
