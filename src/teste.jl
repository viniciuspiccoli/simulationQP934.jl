
# Write your package code here.

using simulationQP934

data = Data();
box = initial_point(data);
nc, fatm, natm = linkedlist(box,data);

using BenchmarkTools, Test

@btime utotal($box, $data, $fatm, $natm, $nc)
@btime utotal_parallel($box, $data, $fatm, $natm, $nc)
@btime utotal_parallel2($box,$data,$fatm,$natm,$nc)


