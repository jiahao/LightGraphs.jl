### Writing a Graph
Graphs may be written to I/O streams and files using the `write` function:

`write(io, g)`  
Writes a graph in a proprietary format (see [internals]("internals")) to the IO stream designated by `io`.

`write(g, fn[, compress=true])`  
Writes a graph to a file `fn`, with default `GZip` compression.

Both `write` functions will return tuples containing the number of vertices and number of edges written.

### Reading a Graph From a File
Graphs stored using the `write` functions above may be loaded using `readgraph`:

`readgraph(fn)`  
Returns a graph loaded from file `fn`.


###Examples
```julia
julia> write(STDOUT, g)
julia> write(g, "mygraph.jgz")
julia> g = readgraph("mygraph.jgz")
```
