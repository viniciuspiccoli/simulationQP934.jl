## Data structure for the simulations

using Parameters

@with_kw struct Data
 
  # particle data
  eps :: Float64  = 5.0
  sig :: Float64  = 0.5
  mass :: Float64 = 1.0

  # box side and cutoff information
  cutoff :: Float64 = 3.
  side :: Float64   = 150.

  # number of particles
  N :: Int64 = 400

  # Data for computation of ljpair
  eps4 :: Float64  = 4*eps
  sig6 :: Float64  = sig^6
  sig12 :: Float64 = sig^12

end




