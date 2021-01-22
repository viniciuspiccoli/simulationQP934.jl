function initial_velocity(N::Int64;T=298.15,R=8.3145,m=1.0)
  vel = [ [0.,0.] for i in 1:N]
  angle = 2*pi*rand()

  for i in 1:N
    px = rand()
    py = rand()
    vel[i][1] = sqrt(-(2*R*T/m)*log(1-px)) * angle       # velocity in the x axis 
    vel[i][2] = sqrt(-(2*R*T/m)*log(1-py)) * angle       # velocity in the y axis
  end

  return vel
end

function norm(x::Vector{Float64})
  s = 0.
  for i in 1:length(x)  
    s = s + x[i]^2
  end
  sqrt(s)  
end

function normVEL(x)
  s = zeros(length(x))
  for i in 1:length(x)
    s[i] = norm(x[i])        
  end 
  return s
end

export initial_velocity, norm, normVEL


# p(v)dv
p(v;m=1.,R=8.3145,T=298.15) = m/(R*T) * v * exp(-m*v^2/(2R*T)) 

# probability v < x
pv(x;m = 1., T = 298.15, R = 8.3145) = -exp(-m*x^2/(2*R*T)) + 1





