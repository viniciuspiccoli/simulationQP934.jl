 # function to allocate data using linked lists

  function linkedlist(box, DATA)                        # Box = points, side = box's side, cutoff 
    Nc = trunc(Int64 ,DATA.side / DATA.cutoff)          # Number of cells
    first_atom = zeros(Int64,Nc, Nc)                    # vector that contain the first atom of each cell
    next_atom  = zeros(Int64, DATA.N)                   # vector that that the value of a atom position correponds to the next atom's position

    for iat in 1:DATA.N
      icell = trunc(Int64, box[iat][1]/DATA.cutoff) + 1      #  classification of each particle in a specific cell
      jcell = trunc(Int64, box[iat][2]/DATA.cutoff) + 1      #

      if icell==0
        icell = icell + 1
      end
     
      if jcell ==0
        jcell = jcell + 1 
      end  
       
      next_atom[iat] = first_atom[icell, jcell]         #    saving the next atom
      first_atom[icell, jcell] = iat                    #    saving the first atom
    end

    return Nc, first_atom, next_atom
  end

