# Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX
include("mainTP1.jl")
include("mainTP3.jl")
include("load.jl")

# -------------------------------------------- SOLVEURS --------------------------------------------------------
# Proceeding to the optimization
solverSelectedLP = GLPKSolverLP()
solverSelectedMIP = GLPKSolverMIP()
solverSelectedCPLEX = CplexSolver()


function solveLotSizing(typeProbleme,nomInstance)
  if typeof(nomInstance) == String
  #---------------------------------------- ULS -----------------------------------------------
    if typeProbleme == "ULS"
      P,F,H,D = loadPb(nomInstance)
      T       = length(D)
      # M est une constante de valeur très grande, ici 100
      M       = fill(100,T)
      # appelle au branch and bound pour ULS
      tic = time()
      resolutionMonoProduit(solverSelectedLP,D,P,H,F,M)
      tac = time() - tic
      println();print("Time = ",round(tac,2));println(" Secondes")
    #-------------------------------------- CLS -----------------------------------------------
    elseif typeProbleme == "CLS"
      P,F,H,D = loadPb(nomInstance)
      T       = length(D)
      # capacité M à produire
      M       = fill(100,T)
      for t = 1:T
        M[t] = sum(D[k] for k=t:T)
      end
      # appelle au branch and bound pour CLS
      tic = time()
      resolutionMonoProduit(solverSelectedLP,D,P,H,F,M)
      tac = time() - tic
      println();print("Time = ",round(tac,2));println(" Secondes")
    #------------------------------------  MCLS  ----------------------------------------------
    elseif typeProbleme == "MCLS"
      P,F,H,D,C,B = loadPbMCLS(nomInstance)
      N,T         = size(D)
      V           = ones(N,T)
      PHI         = zeros(N,T)
      M           = zeros(N,T)
      for i=1:N
        for t=1:T
          M[i,t] = sum(D[i,k] for k=t:T)
            # M[i,t] = max(M[i,t],C[t])
            # M[i,t] = minimum(M)
        end
      end
      tic = time()
      # ********************** Jouer sur une petite instance (8x8 etant long)*******************
      n = 5
      t = 5
      P1 = zeros(n,t)
      F1 = zeros(n,t)
      H1 = zeros(n,t)
      D1 = zeros(n,t)
      C1 = zeros(t)
      B1 = zeros(n,t)
      M1 = zeros(n,t)
      V1 = zeros(n,t)
      PHI1 = zeros(n,t)
      for i = 1:n
        for k = 1:t
          P1[i,k] = P[i,k]
          F1[i,k] = F[i,k]
          H1[i,k] = H[i,k]
          D1[i,k] = D[i,k]
          C1[k] = C[k]
          B1[i,k] = B[i,k]
          M1[i,k] = M[i,k]
          V1[i,k] = V[i,k]
          PHI1[i,k] = PHI[i,k]
        end
      end
      # ************************************************************************
      resolutionMultiProduit(solverSelectedLP,D1,P1,H1,F1,B1,C1,M1,V1,PHI1)
      # appelle au branch and bound MCLS
      # resolutionMultiProduit(solverSelectedLP,D,P,H,F,B,C,M,V,PHI)
      tac = time() - tic
      println();print("Time = ",round(tac,2));println(" Secondes")
    #---------------------------------------------------------------------------------------
    else
      println("typeProbleme : non reconnu ")
    end
  else
    println("nonInstance : Format inconnu (il doit etre de type String)")
  end
end

# =================================================================================================#
#                       LANCEMENT SOLUTION LOGICIEL
#==================================================================================================#
 solveLotSizing("MCLS","../data/pp08a.dat")
# solveLotSizing("ULS","../data/instanceT5.dat")
# solveLotSizing("CLS","../data/instanceT5.dat")




####################################################
#       Ces fonctions sont egalement implémentés
#        1) Model MIP (paramètre = "CPLEX" ou "GLPK")
#         modelMip_MonoProduit("CPLEX")
#        2) Amélioration3 Model Tp1  ( GLPK est utilisé)
#         formulationmodel3Tp1()
#        3) Model MIP (paramètre = "CPLEX" ou "GLPK")
#         modelMIP_MCLS("CPLEX")
#        4) Model LP (GLPK est utilié)
#         modelLp_MCLS()
####################################################
