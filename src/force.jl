# force calculation using linked lists method


#prreciso acertar isso daqui


# f = [ [0. , 0.] for i in 1:data.N ]
 fvec(data) = [ Vector{Float64}(undef,2) for i in 1:data.N ]

function force!(box, DATA, frc, first_atom, next_atom, nc)
  ut = 0.

  for i in 1:length(frc)
    frc[i][1] = 0.
    frc[i][2] = 0. 
  end
  
  for iat in 1:DATA.N
    icell = trunc(Int64,box[iat][1]/DATA.cutoff) + 1
    jcell = trunc(Int64,box[iat][2]/DATA.cutoff) + 1
    for i in icell-1:icell+1
      for j in jcell-1:jcell+1
        iw, jw = wrapcell(nc, i, j) 
        jat = first_atom[iw,jw]
        while jat > 0
          if jat > iat
            rij = pbcseparation(box[jat],box[iat],DATA.side)
            if rij <= 2.
              up,fp = fpair(box[jat], box[iat], rij, DATA)
              frc[iat] .= frc[iat] .+ fp  
              frc[jat] .= frc[jat] .- fp            
              ut += up
            end
          end
          jat = next_atom[jat]
        end
      end
    end
  end
  return ut 
end

export fvec, force!








