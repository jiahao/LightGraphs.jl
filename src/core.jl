abstract AbstractGraph
abstract AbstractPathState

typealias Edge Pair{Int,Int}

src(e::Edge) = e.first
dst(e::Edge) = e.second

rev(e::Edge) = Edge(e.second,e.first)

==(e1::Edge, e2::Edge) = (e1.first == e2.first && e1.second == e2.second)

function show(io::IO, e::Edge)
    print(io, "edge $(e.first) - $(e.second)")
end

vertices(g::AbstractGraph) = g.vertices
edges(g::AbstractGraph) = g.edges

function =={T<:AbstractGraph}(g::T, h::T)
    return (vertices(g) == vertices(h)) && (edges(g) == edges(h))
end

function issubset{T<:AbstractGraph}(g::T, h::T)
    (gmin, gmax) = extrema(vertices(g))
    (hmin, hmax) = extrema(vertices(h))
    return (hmin <= gmin <= gmax <= hmax) &&
    issubset(edges(g), edges(h))
end

function add_vertex!(g::AbstractGraph)
    n = length(vertices(g)) + 1
    g.vertices = 1:n
    push!(g.badjlist, Int[])
    push!(g.fadjlist, Int[])

    return n
end

function add_vertices!(g::AbstractGraph, n::Integer)
    for i = 1:n
        add_vertex!(g)
    end
    return nv(g)
end

has_edge(g::AbstractGraph, src::Int, dst::Int) = has_edge(g,Edge(src,dst))

in_edges(g::AbstractGraph, v::Int) = [Edge(x,v) for x in g.badjlist[v]]
out_edges(g::AbstractGraph, v::Int) = [Edge(v,x) for x in g.fadjlist[v]]

has_vertex(g::AbstractGraph, v::Int) = v in vertices(g)

nv(g::AbstractGraph) = length(vertices(g))
ne(g::AbstractGraph) = length(edges(g))

add_edge!(g::AbstractGraph, src::Int, dst::Int) = add_edge!(g, Edge(src,dst))

rem_edge!(g::AbstractGraph, src::Int, dst::Int) = rem_edge!(g, Edge(src,dst))

is_directed(g::AbstractGraph) = (typeof(g) == Graph? false : true)

indegree(g::AbstractGraph, v::Int) = length(g.badjlist[v])
outdegree(g::AbstractGraph, v::Int) = length(g.fadjlist[v])


indegree(g::AbstractGraph, v::AbstractArray{Int,1} = vertices(g)) = [indegree(g,x) for x in v]
outdegree(g::AbstractGraph, v::AbstractArray{Int,1} = vertices(g)) = [outdegree(g,x) for x in v]
degree(g::AbstractGraph, v::AbstractArray{Int,1} = vertices(g)) = [degree(g,x) for x in v]
#Δ(g::AbstractGraph) = maximum(degree(g))
#δ(g::AbstractGraph) = minimum(degree(g))
Δout(g) = noallocextreme(outdegree,(>), typemin(Int), g)
δout(g) = noallocextreme(outdegree,(<), typemax(Int), g)
δin(g)  = noallocextreme(indegree,(<), typemax(Int), g)
Δin(g)  = noallocextreme(indegree,(>), typemin(Int), g)
δ(g)    = noallocextreme(degree,(<), typemax(Int), g)
Δ(g)    = noallocextreme(degree,(>), typemin(Int), g)

#"computes the extreme value of [f(g,i) for i=i:nv(g)] without gathering them all"
function noallocextreme(f, comparison, initial, g)
    value = initial
    for i in 1:nv(g)
        funci = f(g, i)
        if comparison(funci, value)
            value = funci
        end
    end
    return value
end

degree_histogram(g::AbstractGraph) = (hist(degree(g), 0:nv(g)-1)[2])

neighbors(g::AbstractGraph, v::Int) = g.fadjlist[v]
in_neighbors(g::AbstractGraph, v::Int) = g.badjlist[v]
out_neighbors(g::AbstractGraph, v::Int) = g.fadjlist[v]
common_neighbors(g::AbstractGraph, u::Int, v::Int) = intersect(neighbors(g,u), neighbors(g,v))
