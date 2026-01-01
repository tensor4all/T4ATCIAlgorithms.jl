using Test
using Random

import QuanticsGrids as QG
using T4ATensorCI
#import T4ATensorCI as TCI
import TensorCrossInterpolation as TCI
import T4ATCIAlgorithms as TCIA
using HubbardAtoms
using SparseIR

import T4ATCIAlgorithms:
    create_node,
    add!,
    find_node,
    all_nodes,
    delete!,
    ProjTensorTrain,
    Projector,
    project,
    ProjTTContainer,
    adaptivematmul,
    BlockStructure,
    matmul

@testset "adaptivematmul" begin
    @testset "2d Gaussians" begin
        Random.seed!(1234)
        gaussian(x, y) = exp(-0.5 * (x^2 + y^2))
        R = 20
        xmax = 10.0
        grid = QG.DiscretizedGrid{2}(R, (-xmax, -xmax), (xmax, xmax))
        grid1 = QG.DiscretizedGrid{1}(R, -xmax, xmax)
        localdims = fill(4, R)
        sitedims = [[2, 2] for _ in 1:R]
        qf = x -> gaussian(QG.quantics_to_origcoord(grid, x)...)
        pordering = TCIA.PatchOrdering(collect(1:R))

        expttpatches = reshape(
            TCIA.adaptiveinterpolate(
                TCIA.makeprojectable(Float64, qf, localdims),
                pordering;
                verbosity=0,
                maxbonddim=30,
            ),
            sitedims,
        )

        product = TCIA.adaptivematmul(expttpatches, expttpatches, pordering; maxbonddim=50)

        nested_quantics(x, y) = [
            collect(p) for p in
            zip(QG.origcoord_to_quantics(grid1, x), QG.origcoord_to_quantics(grid1, y))
        ]

        points = [(rand() * 10 - 5, rand() * 10 - 5) for i in 1:100]
        expproduct(x, y) = sqrt(π) * exp(-0.5 * (x^2 + y^2))

        @test isapprox(
            [expproduct(p...) for p in points],
            (2xmax / 2^R) .* [product(nested_quantics(p...)) for p in points], #(2xmax/2^R) = Δx, Δy
            atol=1e-3,
        )
    end

end
