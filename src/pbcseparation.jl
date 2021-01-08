
 # function to calculate the distance between two points according to the minimal-distance convention 

 function pbcseparation(x::Vector{Float64},y::Vector{Float64}, L)
   d = 0.
   for i in 1:2
     dx = (y[i] - x[i])%L       # difference between y and x
     if dx > L / 2
       dx = dx - L
     elseif dx < -L/2 
       dx = dx + L
     end
     d = d + dx^2
   end
   return sqrt(d)
 end

 function pbcseparation(x::Float64,y::Float64,L)
   dx = (y - x)%L   
   if dx > L / 2
     dx = dx - L
   elseif dx < -L/2
     dx = dx + L
   end

   return sqrt(dx^2)
 end

export pbcseparation

