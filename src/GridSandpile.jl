"""
$(TYPEDSIGNATURES)

Iterate through indices of neighbors of a point in a finite N-dimensional grid.

Invalid indices (those that go outsize the bounds of the grid) are skipped.
"""
function gridneighbors(gridsize::NTuple{N, Int}, index::NTuple{N, Int}) where N
	Channel{NTuple{N, Int}}(0) do channel
		for (dim, (dsize, i)) in enumerate(zip(gridsize, index))
			i > 1 && put!(channel, (index[1:(dim-1)]..., i - 1, index[(dim+1):end]...))
			i < dsize && put!(channel, (index[1:(dim-1)]..., i + 1, index[(dim+1):end]...))
		end
	end
end


"""
$(TYPEDEF)

A sandpile on an N-dimensional grid.

This class implements the AbstractArray interface.
"""
struct GridSandpile{T <: Integer, N} <: AbstractSandpile{T}
	a::Array{T, N}
end

GridSandpile{T}(dims::Tuple) where T = GridSandpile(zeros(T, dims))
GridSandpile{T}(dims::Int...) where {T, N} = GridSandpile{T}(dims)
GridSandpile(args...) = GridSandpile{Int}(args...)
GridSandpile{T}(s::GridSandpile) where T = GridSandpile(convert(T, s.a))
GridSandpile(s::GridSandpile) = GridSandpile(copy(s.a))


# AbstractArray interface
Base.keys(s::GridSandpile) = keys(IndexCartesian(), s.a)
Base.size(s::GridSandpile) = size(s.a)
Base.getindex(s::GridSandpile, args...) = getindex(s.a, args...)
Base.setindex!(s::GridSandpile, args...) = setindex!(s.a, args...)

"""
$(TYPEDSIGNATURES)

Create an uninitialized [`GridSandpile`](@ref) with the same dimensions as an
existing `GridSandpile`.
"""
Base.similar(s::GridSandpile) = GridSandpile(similar(s.a))


isstable(s::GridSandpile, index::Tuple) = 0 .<= s.a[index...] .< 4
isstable(s::GridSandpile) = all(0 .<= s.a .< 4)


function stabilize!(s::GridSandpile)
	n, m = size(s)
	toppled = true
	ntoppled = 0

	while toppled
		toppled = false

		for idx in keys(s)
			i, j = Tuple(idx)

			if s[i, j] >= 4
				s[i, j] -= 4
				i > 1 && (s[i-1, j] += 1)
				i < n && (s[i+1, j] += 1)
				j > 1 && (s[i, j-1] += 1)
				j < m && (s[i, j+1] += 1)
				toppled = true
				ntoppled += 1
			end
		end
	end

	return ntoppled
end


"""rdd one or more grains to a single vertex in the GridSandPile."""
function add!(s::GridSandpile, i::Integer, j::Integer, n=1)
	s.a[i, j] += n
	return stabilize!(s)
end

"""Add two GridSandpiles together and return the stabilized result."""
function Base.:+(s1::GridSandpile, s2::GridSandpile)
	sum = GridSandpile(s1.a .+ s2.a)
	stabilize!(sum)
	sum
end

function add!(s1::GridSandpile, s2::GridSandpile)
	s1.a .+= s2.a
	return stabilize!(s1)
end


# https://mathoverflow.net/a/31269/91849
function idpile!(s::GridSandpile)
	# Set to 2c°
	s.a .= 6
	stabilize!(s)

	# 2c - 2c°
	@. s.a = 6 - s.a

	stabilize!(s)
	return s
end


"""Assign random values to a GridSandpile."""
function Random.rand!(s::GridSandpile)
	rand!(s.a, 0:3)
	return s
end


Base.summary(io::IO, s::GridSandpile) = Base.array_summary(io, s, axes(s.a))

function Base.show(io::IO, ::MIME"text/plain", s::GridSandpile)
	summary(io, s)
	println(io, ":")
	Base.print_array(io, s.a)
end
