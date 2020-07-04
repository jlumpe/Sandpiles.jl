module Sandpiles

using Random
using DocStringExtensions


export isstable, stabilize!, add!, idpile, idpile!


include("macros.jl")
include("sandpile.jl")


end # module
