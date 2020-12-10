using simulationQP934
using Test

@testset "simulationQP934.jl" begin
    # Write your tests here.
    data = Data();
    box = initial_point(data);
    nc, fatm, natm = linkedlist(box,data);
    @test utotal(box, data, fatm, natm, nc) \approx utotal(box,data)

end
