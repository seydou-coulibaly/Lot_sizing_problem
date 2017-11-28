# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface

include("setULP.jl")
include("branchBound.jl")

# =========================================================================== #

# Setting the data
D = [3, 5, 6, 3, 8]
P = [2, 4, 6, 8, 10]
H = [3, 2, 3, 2, 0]
F = [10, 8, 6, 4, 2]
# Quantité max produite par periode
M = [100, 100, 100, 100, 100]

# Proceeding to the optimization
solverSelectedLP = GLPKSolverLP()
solverSelectedMIP = GLPKSolverMIP()

#=
ip, X, Y, S = setULPMIP(solverSelectedMIP,D,P,H,F,M)
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
=#

branchANDBound(solverSelectedLP,D,P,H,F,M)
