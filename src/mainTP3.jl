## Using the following packages
using JuMP, GLPKMathProgInterface, CPLEX
include("setMCLP.jl")
include("branchBoundM.jl")

# --------------------------------------- Execution Model LP pour multiple produit -----------------------------------------------
function modelLp_MultiProduit(solverSelectedLP,D,V,C,P,F,H,M,PHI,B)
  N,T = size(D)
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
    println("Zopt  = ", getobjectivevalue(ip))

    x = getvalue(X)
    y = getvalue(Y)
    s = getvalue(S)
    r = getvalue(R)

    println("X  : ",x);
    println("Y  : ",y);
    println("S  : ",s);
    println("R  : ",r);

    #=

    println("=======================   X ==========================")
    X = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      X[i,t] = x[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");
        print(trunc(Int,X[i,t]))
      end
      #println(" \\\\ ")
      println()
    end
    println("=======================   Y ==========================")
    Y = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      Y[i,t] = y[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(round(Y[i,t],2))
      end
      #println(" \\\\ ")
      println()
    end
    println("=======================   S ==========================")
    S = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      S[i,t] = s[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(trunc(Int,S[i,t]))
      end
      #println(" \\\\ ")
      println()
    end
    println("=======================   R ==========================")
    R = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      R[i,t] = r[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(trunc(Int,R[i,t]))
      end
      #println(" \\\\ ")
      println()
    end
    =#
  end

end

#-------------------------------------------   Execution Model MIP pour multiple produit  ------------------------------------
function modelMIP_MultiProduit(solver,D,V,C,P,F,H,M,PHI,B)
  N,T = size(D)
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
    println("Zopt  = ", getobjectivevalue(ip))

    x = getvalue(X)
    y = getvalue(Y)
    s = getvalue(S)
    r = getvalue(R)

    println("X  : ",x);
    println("Y  : ",y);
    println("S  : ",s);
    println("R  : ",r);

    #=



    println("=======================   X ==========================")
    X = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      X[i,t] = x[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(round(X[i,t],2) )
      end
      #print("\\\\")
      println()
    end
    println("=======================   Y ==========================")
    Y = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      Y[i,t] = y[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(trunc(Int,Y[i,t]))
      end
      #print("\\\\")
      println()
    end
    println("=======================   S ==========================")
    S = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      S[i,t] = s[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(trunc(Int,S[i,t]))
      end
      #print("\\\\")
      println()
    end
    println("=======================   R ==========================")
    R = zeros(N,T)
    i = 1
    t = 1
    for k = 1:(N*T)
      R[i,t] = r[k]
      if i == N
        i = 0
        t+=1
      end
      i+=1
    end
    for i = 1:N
      print("P",i);
      for t = 1:T
        print("  ");print(trunc(Int,R[i,t]))
      end
      #print("\\\\")
      println()
    end
    =#
  end

end
