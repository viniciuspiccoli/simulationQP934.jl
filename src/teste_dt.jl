using simulationQP934

data = Data()
md1  = MDinput(dt=1)
md2  = MDinput(dt=0.1)
md3  = MDinput(dt=0.01)
md4  = MDinput(dt=0.001)


println("calculos para dt = 1")
md(data,md1)
println("  ")

println("calculos para dt = 0.1")
md(data,md2)
println("  ")

println("calculos para dt = 0.01")
md(data,md3)
println("  ")

println("calculos para dt = 0.001")
md(data,md4)
println("  ")

