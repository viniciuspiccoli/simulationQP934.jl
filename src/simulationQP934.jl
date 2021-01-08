module simulationQP934
  include("./DATA.jl")          # data structure
  export Data

  include("./wrap_cell.jl")     # function to wrap cells using pbc
  include("./pbcseparation.jl") # calculation of the distance between two particles using periodic boundary conditions 
  include("./linkedlist.jl")    # function to using linked lists to save the particles positions
  export linkedlist 
  
  include("./initial-point.jl")
  export initial_point         # initial configuration
  
  include("./upair.jl")        # lennard-jones energy between two particles
  include("./utotal.jl")
  export utotal
  
  include("./utotal_parallel.jl") # total energy calculated using paralelization
  export utotal_parallel

  # new parallel version
  include("linear_index.jl" )
  export linear_index

  include("./utotal_parallel2.jl") # total energy calculated using paralelization
  export utotal_parallel2


end
