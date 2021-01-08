using simulationQP934
using Test





@testset "simulationQP934.jl" begin
    # Write your tests here.
    data = Data();
    box = initial_point(data);
    nc, fatm, natm = linkedlist(box,data);
    @test utotal(box, data, fatm, natm, nc) \approx utotal(box,data)

    upair,f = fpair(box[1],box[2],r,data)    
    @test upair \approx  -0.2955814601750326   


end
