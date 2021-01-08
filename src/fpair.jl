# function to calcule the force between a pair of particles
function fpair(r,data)
  # F = 4e(12*(sig^12 / r^13) - 6(sig^6)/(r^7) ) / rep = 48esig12 , att = 24esig6
  r6 = r^6  
  r7 = r6 * r
  r13 = (r6^2) * r
  F = (data.rep / r13) - (data.att / r7)
  return F
end


function fpair(x,y,DATA)

  dx = pbcseparation(x[1],y[1],DATA.L) 
  dy = pbcseparation(x[2],y[2],DATA.L) 

  # force component calculation
  dudx1 = fpair(dx, DATA)  
  dudx2 = fpair(dy, DATA)  

  return dudx1, dudx2

end




