
"""
Define a function which is "abstract" and expected to be overridden for a more
specific type of its first argument. Defines a generic fallback method which
throws an error saying the function is not implemented for the given type of
the first argument.

# Usage

```julia
@abstractmethod foo(x, y)

foo(1, 2)

# Output
foo not implemented for x::Int64
```
"""
macro abstractmethod(sig)
	Meta.isexpr(sig, :call) || error("Not a function signature")

	fname = sig.args[1]
	args = sig.args[2:end]

	arg1 = Meta.isexpr(args[1], :parameters) ? args[2] : args[1]
	arg1name::Symbol = Meta.isexpr(arg1, :(::)) ? arg1.args[1] : arg1

	msg = Expr(:string, "$fname not implemented for $arg1name::", :(typeof($(esc(arg1name)))))

	return :($(esc(sig)) = error($msg))
end
