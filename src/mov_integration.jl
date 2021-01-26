using ProgressMeter


function md(data::Data,MDinputs::MDinput)

  @unpack mass, N   = data
  @unpack dt, nsteps, total_time, iprint = MDinputs

  box            = initial_point(data);
  nc, fatm, natm = linkedlist(box,data);
  force_vec      = fvec(data)
  vel            = initial_velocity(data.N); 
  times = 0.

  #implementar arquivo para salvar trajetórias

  file = open("traj.xyz","w")
 
  println(file,"$N")
  println(file,"Frame 1")
  for i in 1:length(box)
    println(file,"H","   ", box[i][1],"   ",box[i][2] ,"   " ,0.0)
  end

  k = 1 

@showprogress 1 "Running - MD " for i in 1:nsteps
    ut = force!(box, data, force_vec, fatm, natm, nc)
    times = times + dt

   # println(i)

    for ip in 1:data.N  
      # positions update @. box[ip] = box[ip] + vel[ip]*dt + force_vec[ip] * (dt*dt)/(2*mass)
      @. box[ip] = box[ip] + vel[ip]*dt + force_vec[ip] * (dt*dt)/(2*mass)
      # velocity update
      @. vel[ip] = vel[ip] + force_vec[ip] * dt/mass
    end

    if i%iprint ==0
      println("Total energy at step $i = $ut")
      
      k += 1
      println(file,"$N")
      println(file,"Frame $k")
      for i in 1:length(box)
        println(file,"H","   ", box[i][1],"   ",box[i][2], "   " ,0.0)
      end
    end

  end
  close(file)
end
