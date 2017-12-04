#=
# --------------------------------------------------------------------------- #
# Setting an ip model of MCLSP
function setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI)
  n,t = size(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:n,1:t] >= 0)
  @variable(ip, 0 <= Y[1:n,1:t] <= 1 )
  @variable(ip, S[1:n,1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i,j] * S[i,j] for i=1:n,j=1:t) +
                    sum(P[i,j] * X[i,j] for i=1:n,j=1:t) +
                    sum(F[i,j] * Y[i,j] for i=1:n,j=1:t))

  #Constraints of problem
  @constraint(ip , cte1[i=2:n,j=1:t], X[i,t]+S[i-1,t]-D[i,t]-S[i,t] == 0)
  @constraint(ip , cte2[j=1:t], X[1,j]-D[1,j]-S[1,j] == 0)
  @constraint(ip , cte3[i=1:n,j=1:t], X[i,j]-M[i,j]*Y[i,j] <= 0)
  @constraint(ip , cte3[j=1:t], sum(V[i,j]*X[i,j] + PHI[i,j]*Y[i,j] for i=1:n))

  return ip, X, Y, S
end
=#
