## Data structure for the simulations

using Parameters

@with_kw struct Data
 
  # particle data
  eps :: Float64 = 5.0
  sig :: Float64 = 0.5
  mass :: Float64 = 1.0

  # box side and cutoff information
  cutoff :: Float64 = 3.0
  side :: Float64 = 150.

  # number of particles
  N :: Int64 = 1_000

  # Data for computation of ljpair
  eps4 :: Float64 = 4*eps
  sig6 :: Float64 = sig^6
  sig12 :: Float64 = sig^12
  
  # Data for computation of fpair
  rep :: Float64 = 48 * eps * sig12        # repulsion composition       
  att :: Float64 = 24 * eps * sig6         # atraction composition

end




