## Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX
include("setMCLP.jl")
include("branchBoundM.jl")

# --------------------------------------- Execution Model LP pour multiple produit -----------------------------------------------
function modelLp_MCLS()
  # paramètre optionnel
  Contraintes = fill(2,N,T)
  ip, X, Y, S, R = setMCLSP(solverSelectedLP,D,V,C,P,F,H,M,PHI,B,Contraintes)
  println("The optimization problem to be solved is:")
  print(ip)
  println("Solving...");
  status = solve(ip)
  # Displaying the results
  if status == :Optimal
    println("status = ", status)
    println("z  = ", getobjectivevalue(ip))

    x = getvalue(X)
    y = getvalue(Y)
    s = getvalue(S)
    r = getvalue(R)

    println("=======================   X ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = (N)*i + t
        print("",round(x[ind],3));print("\t & \t ")
      end
      println()
    end
    println("=======================   Y ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = (N)*i + t
        print("",round(y[ind],2));print(" \t & \t ")
      end
      println()
    end
    println("=======================   S ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = (N)*i + t
        print("",round(s[ind],3));print("\t & \t ")
      end
      println()
    end
    println("=======================   R ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = (N)*i + t
        print("",round(r[ind],3));print("\t & \t  ")
      end
      println()
    end
  end

end

#-------------------------------------------   Execution Model MIP pour multiple produit  ------------------------------------
function modelMIP_MCLS(solver)
  if solver == "CPLEX"
    solverSelect = solverSelectedCPLEX
  else
    solverSelect = solverSelectedMIP
  end
  ip, X, Y, S, R = setMCLSPMIP(solverSelect,D,V,C,P,F,H,M,PHI,B)
  println("The optimization problem to be solved is:")
  print(ip)
  println("Solving...");
  status = solve(ip)
  # Displaying the results
  if status == :Optimal
    println("status = ", status)
    println("z  = ", getobjectivevalue(ip))

    x = getvalue(X)
    y = getvalue(Y)
    s = getvalue(S)
    r = getvalue(R)

    println("=======================   X ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = N*i + t
        print("",round(x[ind],3));print("\t & \t ")
      end
      println()
    end
    println("=======================   Y ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = N*i + t
        print("",round(y[ind],2));print(" \t & \t ")
      end
      println()
    end
    println("=======================   S ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = N*i + t
        print("",round(s[ind],3));print("\t & \t ")
      end
      println()
    end
    println("=======================   R ==========================")
    for t=1:T
      for i=0:(N-1)
        ind = N*i + t
        print("",round(r[ind],3));print("\t & \t  ")
      end
      println()
    end
  end

end
#-----------------------------------------  Execution ------------------------------------------------------------------------
