# function to calcule the force between a pair of particles
# Exercise 39_40
using simulationQP934



#inputs
data = Data();
box  = initial_point(data);
particle1 = box[1];
particle2 = box[2];

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

  dudr1 = -12*(data.sig12/r13)
  dudr2 = -6*(data.sig6/r7)

  dfacdr =  data.eps4*(dudr1 - dudr2)

  upair = data.eps4*(data.sig12/r12 - data.sig6/r6)  
  f = ( -dfacdr*drdx1, -dfacdr*drdx2 ) 

  return upair, f

end


r = pbcseparation(particle1,particle2,data.side)
  
f12 = fpair(particle1,particle2,r,data)

f21 = fpair(particle2,particle1,r,data)





