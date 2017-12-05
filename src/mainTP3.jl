# =========================================================================== #

# Using the following packages
using JuMP, GLPKMathProgInterface
include("setMCLP.jl")
include("branchBound.jl")

# =========================================================================== #

# Setting the data
D = [0 70 50 100 20 80 0 100;
     20 40 50 10 30 0 40 50;
     40 50 0 100 40 80 90 160;
     0 100 100 150 160 90 100 100;
     50 0 20 40 10 10 20 10;
     70 40 40 40 100 20 40 50;
     0 20 50 10 20 60 40 40;
     10 20 0 0 10 10 20 30 ]
P = fill(2,8,8)
H = ones(Int,8,8)
F = [100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ;
     100 200 200 300 400 250 500 300 ]
V = fill(0,8,8)
PHI = zeros(Int,8,8)
C = [350 350 350 400 400 400 400 500]
# Quantité max M produite par periode
M = copy(D)
N,T = size(D)
# Remplissage de la matrice M fixant des capacités de production sur X[i,j]
for i=1:N
  for t=1:T
    M[i,t] = sum(D[i,k] for k=t:T)
  end
end
# ---------------------------------------------------------------------------------------------------------------
# Proceeding to the optimization
solverSelectedLP = GLPKSolverLP()
solverSelectedMIP = GLPKSolverMIP()
#----------------------------------------------------------------------------------------------------------------
# Model pour multiple produit
#----------------------------------------------------------------------------------------------------------------
# ip, X, Y, S = setMCLSP(solverSelectedMIP,D,V,C,P,F,H,M,PHI)
ip, X, Y, S = setMCLSP(solverSelectedLP,D,V,C,P,F,H,M,PHI)
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
  x = println(getvalue(X))
  y = println(getvalue(Y))
  s = println(getvalue(S))
end
x = getvalue(X)
y = getvalue(Y)
s = getvalue(S)
println("=======================   X ==========================")
for t=1:8
  for i=0:7
    ind = 8*i + t
    print("",x[ind]);print(" & ")
  end
  println()
end
println("=======================   Y ==========================")
for t=1:8
  for i=0:7
    ind = 8*i + t
    print("",y[ind]);print(" & ")
  end
  println()
end
println("=======================   S ==========================")
for t=1:8
  for i=0:7
    ind = 8*i + t
    print("",s[ind]);print(" & ")
  end
  println()
end
