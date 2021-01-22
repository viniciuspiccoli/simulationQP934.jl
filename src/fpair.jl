# function to calcule the force between a pair of particles
function fpair(x,y,r,data)

  # r values for F calculation 
  r6  = r^6
  r7  = r6 * r
  r12 = r6^2
  r13 = r12 * r

  # x and y components
  # Fz = -( dU(r) / dz) = - (dr/dz) * (dU(r)/dr), r = sqrt(dx^2,dy^2)     
  # calculation for -(dr/dr) 

  drdx1 = -(x[1]-y[1])/r
  drdx2 = -(x[2]-y[2])/r

  # calculation for (dU(r)/dr)
  dudr1 =  -(data.rep / r13)
  dudr2 =  -(data.att / r7)

  dfdr = - (dudr1 - dudr2) 

  # calculatons of force components  
  f1   =   dfdr * drdx1 
  f2   =   dfdr * drdx2

  f = (-f1,-f2)

  # calculation of energy of interaction
  upair = data.eps4*(data.sig12/r12 - data.sig6/r6)

  return upair, f

end

