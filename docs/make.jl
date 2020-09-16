push!(LOAD_PATH,"../src/")
using Documenter
using CBSOData3

makedocs(
    sitename = "CBSOData3",
    format = Documenter.HTML(),
    modules = [CBSOData3]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/HenricoWitvliet/CBSOData3.jl"
)
