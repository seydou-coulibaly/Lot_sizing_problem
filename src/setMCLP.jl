# ------------------------------------   Model LP ----------------------------------------------------
# Setting an ip model of SLP
function setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI,B,Contraintes)
  N,T = size(D)
  ip = Model(solver=solverSelected)
  #Variables definitions
  @variable(ip, X[1:N,1:T] >= 0)
  @variable(ip, 0 <= Y[1:N,1:T] <= 1)
  @variable(ip, S[1:N,1:T] >= 0)
  @variable(ip, R[1:N,1:T] >= 0)
  #Objectives functions
  @objective(ip, Min,
                    sum(H[i,t] * S[i,t] for i=1:N,t=1:T) +
                    sum(P[i,t] * X[i,t] for i=1:N,t=1:T) +
                    sum(F[i,t] * Y[i,t] for i=1:N,t=1:T) +
                    sum(B[i,t] * R[i,t] for i=1:N,t=1:T)
                  )

  # Constraints of problem
  # constraint 1 (contrôle de flux)
  for i=1:N
    for t=2:T
      @constraint(ip,X[i,t]+R[i,t]-R[i,t-1]+S[i,t-1]-D[i,t]-S[i,t] == 0)
    end
    @constraint(ip,X[i,1]+R[i,1]-D[i,1]-S[i,1] == 0)
  end
  # constraint 2 (if Y = 0 then X == 0)
  for i=1:N
    for t=1:T
      @constraint(ip,X[i,t]-C[t]*Y[i,t] <= 0)
      @constraint(ip,R[i,t] <= D[i,t])
    end
  end
  for t = 1:T
    # ressources capacity constraint
    @constraint(ip,sum(V[i,t]*X[i,t] + PHI[i,t]*Y[i,t] for i=1:N) <= C[t])
  end
  # Contraintes pour branch and bound
  for i = 1:N
    for t = 1:T
      if Contraintes[i,t] != 2
        @constraint(ip,Y[i,t] == Contraintes[i,t])
      end
    end
  end
  return ip, X, Y, S, R
end

# --------------------------------------   Model MIP  ----------------------------------------------------------
function setMCLSPMIP(solverSelected,D,V,C,P,F,H,M,PHI,B)
  N,T = size(D)
  ip = Model(solver=solverSelected)
  #Variables definitions
  @variable(ip, X[1:N,1:T] >= 0)
  @variable(ip,Y[1:N,1:T], Bin )
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
  # constraint 1 (contrôle de flux)
  for i=1:N
    for t=2:T
      @constraint(ip,X[i,t]+R[i,t]-R[i,t-1]+S[i,t-1]-D[i,t]-S[i,t] == 0)
    end
    @constraint(ip,X[i,1]+R[i,1]-D[i,1]-S[i,1] == 0)

  end
  # constraint 2 (if Y = 0 then X == 0)
  for i=1:N
    for t=1:T
      @constraint(ip,X[i,t]-C[t]*Y[i,t] <= 0)
      @constraint(ip,R[i,t] <= D[i,t])
    end
  end
  for t = 1:T
    # ressources capacity constraint
    @constraint(ip,sum(V[i,t]*X[i,t] + PHI[i,t]*Y[i,t] for i=1:N) <= C[t])
  end
  return ip, X, Y, S, R
end
# ----------------------------------------  Model LP mono-Produit avec backlog  -------------------------------------------------------
# Setting an ip model of SLP
function setminLP(solverSelected,D,P,H,F,B,C,M,V,PHI,Contraintes)
  t = length(D)
  t = 4
  ip = Model(solver=solverSelected)

  #Variables definitions
  @variable(ip, X[1:t] >= 0)
  @variable(ip, 0 <= Y[1:t] <= 1 )
  @variable(ip, S[1:t] >= 0)
  @variable(ip, R[1:t] >= 0)

  #Objectives functions
  @objective(ip, Min,
                    sum(H[i] * S[i] for i=1:t) +
                    sum(P[i] * X[i] for i=1:t) +
                    sum(F[i] * Y[i] for i=1:t) +
                    sum(B[t] * R[i] for i=1:t)
                    )

  #Constraints of problem
  @constraint(ip , cte1[i=2:t], X[i]+R[i]-R[i-1]+S[i-1]-D[i]-S[i] == 0)
  @constraint(ip , cte2[i=1:t], X[i]-C[i]*Y[i] <= 0)
  @constraint(ip , cte3, X[1]+R[1]-D[1]-S[1] == 0)
  @constraint(ip,cte4[i=1:t],V[i]*X[i] + PHI[i]*Y[i] <= C[i])

  for i=1:t
    if Contraintes[i] != 2
        @constraint(ip , Y[i] == Contraintes[i])
    end
  end

  return ip, X,Y,S,R
end
