import PyPlot: plt, plot


function plot(s::GridSandpile{T, 2}, ax=nothing; fig=nothing, size=(3, 3), kw...) where T
	if isnothing(ax)
		isnothing(fig) && (fig = plt.figure(figsize=size))
		ax = fig.gca()
	end
	ax.imshow(s.a; cmap="viridis", vmin=0, vmax=3, kw...)
	ax.axis("off")
	fig.tight_layout(pad=0)
end
