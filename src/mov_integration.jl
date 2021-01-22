# tem um erro aqui que não me deixa integrar as equações direito
# está relacionado com o número de partículas
# preciso ajustar isso
#using Statistics


function md(data::Data,MDinputs::MDinput)


  @unpack mass   = data
  @unpack dt, nsteps, total_time, iprint = MDinputs


  box            = initial_point(data);
  nc, fatm, natm = linkedlist(box,data);
  force_vec      = fvec(data)


  vel            = initial_velocity(data.N); 

  times = 0.


  for i in 1:nsteps


    ut = force!(box, data, force_vec, fatm, natm, nc)
    times = times + dt

    for ip in 1:data.N  
     

      # positions update @. box[ip] = box[ip] + vel[ip]*dt + force_vec[ip] * (dt*dt)/(2*mass)

      box[ip][1] = box[ip][1] + vel[ip][1]*dt + force_vec[ip][1] * (dt*dt)/(2*mass)
      box[ip][2] = box[ip][2] + vel[ip][2]*dt + force_vec[ip][2] * (dt*dt)/(2*mass)

      # velocity update
      vel[ip][1] = vel[ip][1] + force_vec[ip][1] * dt/mass
      vel[ip][2] = vel[ip][2] + force_vec[ip][2] * dt/mass

    end

    if i%iprint ==0
      println("Step #$i")
      println("Total energy = ",ut) 
    end

   # println("parameters of the simulation")
   # println("Medium Velocities") 
   # println("Total force")  

    #if i%iprint == 0
    #  println("Total energy at $i = ",ut)
    #end

  end


end
