function ij_pair(N)
  npairs = div(N*(N-1),2)
  ij = Matrix{Int}(undef,npairs,2) 
  for ipair in 1:npairs 
    ij[ipair,1], ij[ipair,2] = linear_index(ipair)
  end
  return ij
end
export ij_pair




# energy calculation using linked lists method
function utotal_parallel2(box, DATA, first_atom, next_atom, nc)

  nthreads = Threads.nthreads()        # number of threads available
  @unpack N, side, cutoff = DATA       # extraction some variables from DATA
  npairs = div(N * (N - 1), 2)         # Number of pairs 
  Ut = zeros(nthreads)                 # vector with nthreads positions 
  n_per_thread = div(N, nthreads)  # number of pairs per thread 
 

  if mod(npairs,nthreads) != 0
    error(" mod(npairs,nthreads) != 0 ")   # return error if npairs % nthreads != 0
  end
  
  
  Threads.@threads for id in 1:nthreads
    ifirst = (id-1)*n_per_thread + 1
    ilast = ifirst - 1 + n_per_thread
   

    for iat in ifirst:ilast

  #    ip = ij[ipair,1]
  #    jp = ij[ipair,2] 

      icell = trunc(Int64,box[iat][1]/cutoff) + 1
      jcell = trunc(Int64,box[iat][2]/cutoff) + 1

 #     println("atribuicao de particulas em celulas")
      

      for i in icell-1:icell+1
        for j in jcell-1:jcell+1

  #        println("loop pelas celulas vizinhas")

          iw, jw = wrapcell(nc, i, j) 
          jat = first_atom[iw,jw]

   #       println("acessando listas ligadas") 
          
    #      println(iat,"   ",jat)
          while jat > 0
            if jat > iat
 
              rij = pbcseparation(box[jat],box[iat],side)
     #         println("calculando distancia entre particulas")
              if rij <= 2.
 
      #          println("calculando") 
                Ut[id] += upair(rij,DATA)
              end
            end
            jat = next_atom[jat]
          end
        end    
      end     
    end    
  end
  return sum(Ut) 
end

