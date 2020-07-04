module Sandpiles

using Random
using DocStringExtensions


export isstable, stabilize!, add!, idpile, idpile!
export GridSandpile


include("macros.jl")
include("sandpile.jl")
include("GridSandpile.jl")


end # module
