# --------------------------------------------------------------------------- #

# Setting an ip model of SLP
function setULPLP(solverSelected,D,P,H,F,M,Contraintes)
  t = length(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, 0 <= Y[1:t] <= 1 )
  @variable(ip, S[1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t))

  #Constraints of problem
  @constraint(ip , cte1[i=2:t], X[i]+S[i-1]-D[i]-S[i] == 0)
  @constraint(ip , cte2[i=1:t], X[i]-M[i]*Y[i] <= 0)
  @constraint(ip , cte3, X[1]-D[1]-S[1] == 0)
  # Inegalités valides
  @constraint(ip , cte4[i=2:t], S[i-1] >= D[i]*(1-Y[i])) #contrainte 22
  for i=1:t
    if Contraintes[i] != 2
        @constraint(ip , Y[i] == Contraintes[i])
    end
  end

  return ip, X, Y, S
end
#--------------------------------------------------------------------------------------------------------------------------
function setULPMIP(solverSelected,D,P,H,F,M)
  t = length(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, Y[1:t], Bin )
  @variable(ip, S[1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t))

  #Constraints of problem
  @constraint(ip , cte1[i=2:t], X[i]+S[i-1]-D[i]-S[i] == 0)
  @constraint(ip , cte2[i=1:t], X[i]-M[i]*Y[i] <= 0)
  @constraint(ip , cte3, X[1]-D[1]-S[1] == 0)


  return ip, X, Y, S
end

# --------------------------------------------------------------------------- #

# Setting an ip model of SLP
function model3(solverSelected,D,P,H,F,M,Contraintes)
  t = length(D)
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, 0 <= Y[1:t] <= 1 )
  @variable(ip, S[1:t] >= 0)
  @variable(ip, W[1:t,1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t))

  #Constraints of problem
  @constraint(ip , cte1[j=1:t], sum(W[i,j] for i=1:j) == D[j])
  @constraint(ip , cte2[i=1:t,j=1:t], W[i,j] <= D[j]*Y[i])
  @constraint(ip , cte3[i=1:t], X[i] == sum(W[i,j] for j=i:t))
  @constraint(ip , cte4[i=1:t-1], S[i] == sum(X[j]-D[j] for j=1:i))
  for i=1:t
    if Contraintes[i] != 2
        @constraint(ip , Y[i] == Contraintes[i])
    end
  end
  return ip, X, Y, S
end
