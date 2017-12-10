# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX

include("setULP.jl")
include("branchBound.jl")


#------------------------------------------ Execution Model MIP tp1 -------------------------------------------------------
function modelMip_MonoProduit(solverSelected,D,P,H,F,M)
  ip, X, Y, S = setULPMIP(solverSelected,D,P,H,F,M)
  println("The optimization problem to be solved is:")
  print(ip)
  println("Solving...");
  status = solve(ip)

  # Displaying the results
  if status == :Optimal
    println("status = ", status)
    println("z  = ", getobjectivevalue(ip))
    print("x  = "); println(getvalue(X))
    print("y  = "); println(getvalue(Y))
    print("s  = "); println(getvalue(S))
  end
end


#---------------------------------------- Execution Modele3 amelioration tp1  ----------------------------------------------
function formulationmodel3Tp1(solverSelected,D,P,H,F,M)
  # C : Paramètre optionnel
  C = [2,2,2,2,2]
  ip, X, Y, S = model3(solverSelectedLP,D,P,H,F,M,C)
  println("The optimization problem to be solved is:")
  print(ip)
  println("Solving...");
  status = solve(ip)

  # Displaying the results
  if status == :Optimal
    println("status = ", status)
    println("z  = ", getobjectivevalue(ip))
    print("x  = "); println(getvalue(X))
    print("y  = "); println(getvalue(Y))
    print("s  = "); println(getvalue(S))
    end
end
