module Sandpiles

using Random
using DocStringExtensions
using Requires


export isstable, stabilize!, add!, idpile, idpile!
export GridSandpile


include("macros.jl")
include("sandpile.jl")
include("GridSandpile.jl")


function __init__()
	@require PyPlot="d330b81b-6aea-500a-939a-2ce795aea3ee" include("pyplot.jl")
end


end # module
