# function to calcule the force between a pair of particles
#function fpair(r,data)
#  # F = 4e(12*(sig^12 / r^13) - 6(sig^6)/(r^7) ) / rep = 48esig12 , att = 24esig6
#  r6 = r^6  
#  r7 = r6 * r
#  r13 = (r6^2) * r
#  F = (data.rep / r13) - (data.att / r7)
#  return F
#end


function fpair(x,y,r,data)

  # r values for F calculation 
  r6 = r^6
  r7 = r6 * r
  r12 = r6^2
  r13 = r12 * r

  # x and y components
  # Fz = -( dU(r) / dz) = - (dr/dz) * (dU(r)/dr), r = sqrt(dx^2,dy^2)     
  # calculation for -(dr/dr) 

  drdx1 = -(x[1]-y[1])/r
  drdx2 = -(x[2]-y[2])/r

  # calculation for (dU(r)/dr)
  dudr1 = -(data.rep / r13)
  dudr2 =  (data.att / r7)

  # calculatons of force components  
  f1 = dudr1* drdx1 + dudr2*drdx2
  f2 = dudr2* drdx2 + dudr2*drdx2
    
  f = (f1,f2)

  # calculation of energy of interaction
  upair = data.eps4*(data.sig12/r12 - data.sig6/r6)


# f1 =  ((data.rep / r13) - (data.att / r7))*drdx1
# f2 =  ((data.rep / r13) - (data.att / r7))*drdx2
#  dx = pbcseparation(x[1],y[1],DATA.side) 
#  dy = pbcseparation(x[2],y[2],DATA.side) 
#
#  # force component calculation
#  dudx1 = fpair(dx, DATA)  
#  dudx2 = fpair(dy, DATA)  

  return upair, f

end

