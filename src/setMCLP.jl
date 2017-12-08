# --------------------------------------------------------------------------- #

# Setting an ip model of SLP
function setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI,B)
  N,T = size(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:N,1:T] >= 0)
  @variable(ip, 0 <= Y[1:N,1:T] <= 1)
  # @variable(ip,Y[1:N,1:T], Bin )
  @variable(ip, S[1:N,1:T] >= 0)
  @variable(ip, R[1:N,1:T] >= 0)
  #Objectives functions
  @objective(ip, Min,
                    sum(H[i,t] * S[i,t] for i=1:N,t=1:T) +
                    sum(P[i,t] * X[i,t] for i=1:N,t=1:T) +
                    sum(F[i,t] * Y[i,t] for i=1:N,t=1:T) +
                    sum(B[i,t] * R[i,t] for i=1:N,t=1:T)
                  )

  #Constraints of problem
  #------------------------ constraint 1 (contrôle de flux) -----------------------------------
  for i=1:N
    for t=2:N
      @constraint(ip,X[i,t]+R[i,t]-R[i,t-1]+S[i,t-1]-D[i,t]-S[i,t] == 0)
    end
    @constraint(ip,X[i,1]+R[i,1]-D[i,1]-S[i,1] == 0)

  end
  #------------------------ constraint 2 (if Y = 0 then X == 0) --------------------------------
  for i=1:N
    for t=1:T
      @constraint(ip,X[i,t]-M[i,t]*Y[i,t] <= 0)
      # ressources capacity constraint
      @constraint(ip,sum(V[i,t]*X[i,t] + PHI[i,t]*Y[i,t]) <= C[t])
      @constraint(ip,R[1,t] <= D[i,t])
    end
  end
  return ip, X, Y, S, R
end
