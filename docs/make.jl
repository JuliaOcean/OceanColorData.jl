using Documenter, OceanColorData

makedocs(;
    modules=[OceanColorData],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/gaelforget/OceanColorData.jl/blob/{commit}{path}#L{line}",
    sitename="OceanColorData.jl",
    authors="gaelforget <gforget@mit.edu>",
    warnonly = [:cross_references,:missing_docs],
)

deploydocs(;
    repo="github.com/gaelforget/OceanColorData.jl",
)
