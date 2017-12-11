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


function solveLotSizing(typeProbleme,nomInstance,solver)
  if typeof(nomInstance) == String
  #---------------------------------------- ULS -----------------------------------------------
    if typeProbleme == "ULS"
      P,F,H,D = loadPb(nomInstance)
      T       = length(D)
      # M est une constante de valeur très grande, ici 100
      M       = fill(100,T)
      print(T);println(" Périodes")
      tic = time()
      if solver == "GLPK"
        solverSelected = solverSelectedMIP
        modelMip_MonoProduit(solverSelected,D,P,H,F,M)
      elseif solver == "CPLEX"
        solverSelected = solverSelectedCPLEX
        modelMip_MonoProduit(solverSelected,D,P,H,F,M,)
      else
        resolutionMonoProduit(solverSelectedLP,D,P,H,F,M)
      end
      # calcule du temps effectué
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
      print(T);println(" Périodes")
      tic = time()
      if solver == "GLPK"
        solverSelected = solverSelectedMIP
        modelMip_MonoProduit(solverSelected,D,P,H,F,M)
      elseif solver == "CPLEX"
        solverSelected = solverSelectedCPLEX
        modelMip_MonoProduit(solverSelected,D,P,H,F,M)
      else
        resolutionMonoProduit(solverSelectedLP,D,P,H,F,M)
      end
      # calcule du temps effectué
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
      println();print(N);print(" Produits")
      print(" ET ");print(T);println(" Périodes")
      tic = time()
      if solver == "GLPK"
        modelMIP_MultiProduit("GLPK",D,V,C,P,F,H,M,PHI,B)
      elseif solver == "CPLEX"
        modelMIP_MultiProduit("CPLEX",D,V,C,P,F,H,M,PHI,B)
      else
        resolutionMultiProduit(solverSelectedLP,D,P,H,F,B,C,M,V,PHI)
      end
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
# solveLotSizing("MCLS","../data/pp05a.dat","GLPK")
# solveLotSizing("ULS","../data/instanceT5.dat","BB")
# solveLotSizing("CLS","../data/instanceT5.dat","BB")




####################################################
#       Ces fonctions sont egalement implémentés
#        1) Model MIP (paramètre = "CPLEX" ou "GLPK")
#         modelMip_MonoProduit("CPLEX")
#        2) Amélioration3 Model Tp1  ( GLPK est utilisé)
#         formulationmodel3Tp1()
#        3) Model MIP (paramètre = "CPLEX" ou "GLPK")
#         modelMIP_MultiProduit("CPLEX",D,V,C,P,F,H,M,PHI,B)
#        4) Model LP (GLPK est utilié)
#         modelLp_MultiProduit(solverSelectedLP,D,V,C,P,F,H,M,PHI,B)
####################################################
