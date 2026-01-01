using T4ATCIAlgorithms
using Documenter

DocMeta.setdocmeta!(T4ATCIAlgorithms, :DocTestSetup, :(using T4ATCIAlgorithms); recursive=true)

makedocs(;
    modules=[T4ATCIAlgorithms],
    authors="Hiroshi Shinaoka <h.shinaoka@gmail.com> and contributors",
    sitename="T4ATCIAlgorithms.jl",
    format=Documenter.HTML(;
        canonical="https://github.com/tensor4all/T4ATCIAlgorithms.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=["Home" => "index.md"],
    remotes=nothing,
)

deploydocs(; repo="github.com/tensor4all/T4ATCIAlgorithms.jl.git", devbranch="main")
