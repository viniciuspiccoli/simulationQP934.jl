  # wrap function -  using periodic boundary conditions to resize i and j of cells 
  function wrap_cell(dms,id,jd)  
    i = dms[1]  
    j = dms[2]
   
    if id < 1
      while id < 1
        id = id + i
      end
    elseif id > i
      while id > i
        id = id - i 
      end 
    end 

    if jd < 1
      while jd < 1
        jd = jd + j
      end
    elseif jd > j
      while jd > j
        jd = jd - j 
      end 
    end
    return id, jd
  end 


  function wrapcell(nc,i,j)
    if i < 1
      i = nc + i
    elseif i > nc
      i = i - nc
    end
    if j < 1
      j = nc + j
    elseif j > nc
     j = j - nc
    end
    return i,j 
  end

