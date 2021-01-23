# Data structure for the simulation start
 
using Parameters

@with_kw struct MDinput

  temp       :: Float64 = 298.15
  total_time :: Float64 = 10
  dt         :: Float64 = 0.01
  nsteps     :: Int64   = 10000 #       trunc(Int64,total_time / dt)
  iprint     :: Int64   = 100

end

export MDinput
