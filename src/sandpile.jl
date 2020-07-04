"""
Abstract base type for various implementations of sandpile models on different types of graphs.
"""
abstract type AbstractSandpile{T} end


"""
	isstable(s::AbstractSandpile, index)::Bool

Check if a given vertex in a sandpile is stable, i.e. its value is less than its
degree.
"""
@abstractmethod isstable(s::AbstractSandpile, index)

"""
	isstable(s::AbstractSandpile)::Bool

Check if the entire sandpile is in a stable configuration.
"""
isstable(s::AbstractSandpile) = all(isstable(s, index) for index in keys(s))


"""
	stabilize!(s::AbstractSandpile)

Iteratively topple all unstable indices in a sandpile until it becomes stable.
Returns the number of topples performed.
"""
@abstractmethod stabilize!(s::AbstractSandpile)


"""
	add!(s::AbstractSandpile, index, n=1)

Add one or more grains to a single vertex in a sandpile and stabilize it.
"""
function add!(s::AbstractSandpile, i::Integer, j::Integer, n=1)
	s.a[index] += n
	return stabilize!(s)
end


"""
	add!(s::AbstractSandpile, s2::AbstractSandpile)

Add values of one sandpile to another of identical shape, modifying the first
argument in place.
"""
@abstractmethod add!(s1::AbstractSandpile, s2::AbstractSandpile)


"""
	idpile!(s::AbstractSandpile)

Modify a sandpile's values to make it the identity for its shape.
"""
@abstractmethod idpile!(s::AbstractSandpile)


"""
	idpile(S, args...)

Construct a sandpile of type `S` with arguments `args` and initialize its values
to be the identity.
"""
function idpile(S::Type{<:AbstractSandpile}, args...)
	s = S(args...)
	idpile!(s)
	return s
end


"""
	rand!(s::AbstractSandpile)

Assign random (stable) values to all indices of a sandpile. Returns its argument.
"""
@abstractmethod Random.rand!(s::AbstractSandpile)


"""
	rand(S, args...)

Construct a sandpile of type `S` with arguments `args` and initialize its values
to be the identity.
"""
function Random.rand(S::Type{<:AbstractSandpile}, args...)
	s = S(args...)
	rand!(s)
	return s
end
