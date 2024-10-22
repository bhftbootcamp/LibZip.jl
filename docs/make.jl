using LibZip
using Documenter

DocMeta.setdocmeta!(LibZip, :DocTestSetup, :(using LibZip); recursive = true)

makedocs(;
    modules = [LibZip],
    sitename = "LibZip.jl",
    format = Documenter.HTML(;
        repolink = "https://github.com/bhftbootcamp/LibZip.jl",
        canonical = "https://bhftbootcamp.github.io/LibZip.jl",
        edit_link = "master",
        assets = ["assets/favicon.ico"],
        sidebar_sitename = true,  # Set to 'false' if the package logo already contain its name
    ),
    pages = [
        "Home"    => "index.md",
        "pages/api_reference.md",
        "pages/constants.md",
    ],
    warnonly = [:doctest, :missing_docs],
)

deploydocs(;
    repo = "github.com/bhftbootcamp/LibZip.jl",
    devbranch = "master",
    push_preview = true,
)
