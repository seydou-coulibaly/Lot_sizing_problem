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
M = copy(D)
t = length(D)
for i=1:t
  M[i] = sum(D[k] for k=i:t)
end

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

#=
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
=#
