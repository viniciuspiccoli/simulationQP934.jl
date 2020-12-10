
# Write your package code here.

include("./utotal_naive.jl")
include("./DATA.jl")
include("./wrap_cell.jl")
include("./pbcseparation.jl")
include("./linkedlist.jl")
include("./initial-point.jl")
include("./upair.jl")
include("./utotal.jl")


data = Data();
box = initial_point(data);
nc, fatm, natm = linkedlist(box,data);

println(utotal(box, data, fatm, natm, nc))
println(utotal(box,data))


