# energy calculation using linked lists method
function utotal_parallel(box, DATA, first_atom, next_atom, nc)

  nthreads = Threads.nthreads()     # number of threads available
  Ut = zeros(nthreads)              # vector with nthreads positions 

 Threads.@threads  for iat in 1:DATA.N                  # paralelization through the particles     
    icell = trunc(Int64,box[iat][1]/DATA.cutoff) + 1
    jcell = trunc(Int64,box[iat][2]/DATA.cutoff) + 1
    for i in icell-1:icell+1
      id = Threads.threadid()
      for j in jcell-1:jcell+1
        iw, jw = wrapcell(nc, i, j) 
        jat = first_atom[iw,jw]
        while jat > 0
          if jat > iat
            rij = pbcseparation(box[jat],box[iat],DATA.side)
            if rij <= 2.
              Ut[id] += upair(rij,DATA)
            end
          end
          jat = next_atom[jat]
        end
      end
    end
  end
  return Ut 
end

