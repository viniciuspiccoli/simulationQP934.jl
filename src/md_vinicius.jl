# molecular dynamics code (first attempt) - version 1
# Vinicius Piccoli - 29/04/2020

using ProgressMeter


  # pbc

  function pbcposition(s,L)
    if s > L
      s = s - L
    elseif s < 0	
      s = s + L
    end
    return s
  end
  
 function  pbcseparation(ds,L)
   if ds > 0.5*L
     ds = ds - L
   elseif ds < -0.5*L
     ds = ds + L
   end   
   return ds 
 end

  #velocities

  function  setVelocities(N,intEner)
    vxSum = 0.0
    vySum = 0.0
   
    # arryas

    vx = zeros(N)
    vy = zeros(N) 
   
    for i in 1:N
      vx[i] = rand() - 0.5 # vx
      vy[i] = rand() - 0.5 # vy
      vxSum = vxSum + vx[i]
      vySum = vySum + vy[i] 
    end
  
    # zero center of mass momentum

    vxcm = vxSum / N
    vycm = vySum / N  
   
    for i in 1:N
      vx[i] = vx[i] - vxcm
      vy[i] = vy[i] - vycm
    end
   
    #rescale velocities to a desired initial kinetic energy

    v2sum = 0

    for i in 1:N
      v2sum = v2sum + vx[i]^2 + vy[i]^2 
    end
    KinectEnergyPerParticle = 0.5*v2sum/N
    rescale = sqrt(intEner/KinectEnergyPerParticle)
    for i in 1:N
      vx[i] = vx[i] * rescale
      vy[i] = vy[i] * rescale
    end
    return vx,vy
  end


# set ramdom variables


# não sei ainda fazer isso funcionar


#code to set random positions restraints
# If the system is a dilute gas, we can choose the initial positions of particles by placing them at random
# , making sure that no two particles are too close to another.

  function setRandomPos(N, Lx, Ly)

    rMinimumSquared  = 2.0 ^ (1.0 / 3.0)
    lx = zeros(N)
    ly = zeros(N)

    # first positions
 
    lx[1] = Lx*rand() 
    ly[1] = Ly*rand()

    j = 1

    for i in 2:N
      
      lx[i] = Lx*rand() # x
      ly[i] = Ly*rand() # y
     
      overlap=true
 
      while j < i && overlap==true   

       dx = pbcseparation(lx[i] - lx[j], Lx)
       dy = pbcseparation(ly[i] - ly[j], Ly)
       if dx*dx + dy*dy <  rMinimumSquared
         while dx*dx + dy*dy <  rMinimumSquared

           lx[i] = Lx*rand()
           ly[i] = Ly*rand()
           dx = pbcseparation(lx[i] - lx[j], Lx)
           dy = pbcseparation(ly[i] - ly[j], Ly)
           if dx*dx + dy*dy > rMinimumSquared
             overlap=false
           end

         end
       end
        
       j = j + 1

      end
    end

    return lx, ly

  end


# Placement of particles on rectangular lattice
# We must specify the number of particles per row nx and the number per collum ny.
# The linear dimensions Lx and Ly are adjustable parameters and can be varied after
# initialization to be as close as possible to their desired values.


  function setRectangular(Lx, Ly, nx, ny)

    dx = Lx / nx # distance between collumns
    dy = Ly / ny # distance between rows
    numx = zeros(nx*ny)
    numy = zeros(ny*nx)

    i = 0
    for ix in 1:nx    # loop through particles in an row
      for iy in 1:ny  # loop through rows

        i = i + 1
        numx[i] = dx * (ix + 0.5)
        numy[i] = dy * (iy + 0.5)

      end
    end
   return numx, numy
  end


  # Computing acceleration

  function accel(N, numx, numy, Lx, Ly)
  
    ax = zeros(N)
    ay = zeros(N)
    
    oneOverR2 = 0
    oneOverR6 = 0

    tpea = 0
    virialAc = 0

    #lennard-jones parameters - 
  
    e = 0.00868
    sig = 3.4

    for i in 1:N
      for j in i+1:N

        dx = pbcseparation(numx[i] - numx[j], Lx)
        dy = pbcseparation(numy[i] - numy[j], Ly)
        r2 = dx*dx + dy*dy

       # fOver =  24 * (e/r2) * (2*(sig/r2)^12 - (sig/r2)^6)  
       # we will truncate the force in r2, thefore particles that have 
       # distance between each other larger than r2 will not have force computed. 

        oneOverR2 = 1.0 / r2
        oneOverR6 = oneOverR2 * oneOverR2 * oneOverR2
        fOver = 48 * oneOverR6 * (oneOverR6 - 0.5) * oneOverR2
 
        fx = fOver * dx
        fy = fOver * dy
      
        ax[i] += fx    # a = f due to reduced units (mass is equal to unity)
        ay[i] += fy 
        ax[j] -= fx 
        ay[j] -= fy

        tpea += 4.0*(oneOverR6 * oneOverR6 - oneOverR6) # total potential energy accumulated
        virialAc += dx*fx + dy*fy # related to mean pressure

      end
    end
    return ax, ay, tpea, virialAc 

  end

# COLOCAR EM UM SCRIPT SEPARADO DE FORMA QUE EU POSSA LER UM ARQUIVO EXTERNO
# CONTENDO OS PARAÂMETROS NECESSÁRIOS PARA A REALIZAÇÃO DA SIMULAÇÃO
# initializing molecular dynamics

let

  num = 2500

# timestep
  dt = 0.01
  dt2 = dt*dt

  time = zeros(num)
  time[1] = 0.

# box length
  Lx = 50  
  Ly = sqrt(3) * Lx / 2  

# number of molecules  
  nx = 15
  ny = 15
  N  = nx * ny # number of molecules
 
# Initial kinect energy
  iner = 6
  
# Initial configuration 
  posx, posy = setRectangular(Lx,Ly,nx,ny) # pos(100, N, Lx, Ly) # setRandomPos(N, Lx, Ly)

# Initial velocities
  vx, vy = setVelocities(N,iner)
  totalKinectenergy = 0.

# calculation of kinect energy
  for j in 1:length(vx)
    totalKinectenergy += (vx[j]*vx[j] + vy[j]*vy[j])
  end
   
# Vectos for potential and kinect energies and for the pressure

 ener = open("energies.dat","w")

 println(ener,"#time    potential    pressure    kinect   square_kin")
 
 PE = zeros(num)
 vir = zeros(num)	
 PK =  zeros(num)
 PK_sqr = zeros(num) # square of PK


 PK[1] = totalKinectenergy * 0.5
 PK_sqr[1] = PK[1]*PK[1]

# Accelerations

 ax, ay, PE[1], vir[1]  = accel(N, posx, posy, Lx, Ly)
 println(ener,round(time[1],digits=3),"    ",round(PE[1],digits=3),"    ",round(vir[1],digits=3),"    ",round(PK[1],digits=3),"    ",round(PK_sqr[1],digits=3))
 
# file contain just the atoms positions
  file2 = open("pos_traj.dat","w")
  println(file2,"# posx    posy")
  println(file2,"# frame 1")
 
  for i in 1:length(posx)
    println(file2," ", posx[i],"    ",posy[i])
  end

# file -
  file = open("traj.xyz","w")
  
  println(file,"$(nx*ny)")
  println(file,"Frame 1")
  for i in 1:length(posx)
   println(file,"H","   ", posx[i],"   ",posy[i] ,"   " ,0.0)
 end

# verlet integrations - num steps

 q = 1
  
 @showprogress 1 "Running- MD of a 2D lennard-jones Gas" for k in 2:num 
   q = q + 1
    
   time[q] = time[q-1] + dt

   # new positions with old accelerations

   totalKinectenergy = 0.
 
   for i in 1:N

     # POSITIONS

     posx[i] = posx[i] + vx[i]*dt + 0.5*ax[i]*dt2 
     posy[i] = posy[i] + vy[i]*dt + 0.5*ay[i]*dt2

     # periodic boundary conditions 
   
     posx[i] = pbcposition(posx[i],Lx)
     posy[i] = pbcposition(posy[i],Ly)

     # VELOCITIES  
   
     vx[i]   = vx[i] + 0.5*ax[i]*dt
     vy[i]   = vy[i] + 0.5*ay[i]*dt

     totalKinectenergy += (vx[i]*vx[i] + vy[i]*vy[i]) 

  end
  
  PK[k] = 0.5*totalKinectenergy
  PK_sqr[k] = PK[k]*PK[k]


   # new accelerations with new positions and new velocities

  ax, ay, PE[k],vir[k] = accel(N, posx, posy, Lx, Ly)
  println(ener,round(time[k],digits=3),"    ",round(PE[k],digits=3),"    ",round(vir[k],digits=3),"    ",round(PK[k],digits=3),"    ",round(PK_sqr[k],digits=3))
 
   # New velocities

  for i in 1:N
    vx[i] = vx[i] + 0.5*ax[i]*dt
    vy[i] = vy[i] + 0.5*ay[i]*dt
  end

 
  # file for the calculation of g(r) 
  println(file2,"# frame $k")
  for i in 1:length(posx)
    println(file2," ", posx[i],"    ",posy[i])
  end

   # vmd file   
   println(file,"$(nx*ny)")
   println(file,"Frame $k")
   for i in 1:length(posx)
     println(file,"H","   ", posx[i],"   ",posy[i] ,"   " ,0.0)
   end

 end
 close(ener)
 close(file)
 close(file2)
end  
