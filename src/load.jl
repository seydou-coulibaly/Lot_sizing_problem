# --------------------------------------------------------------------------- #
# Loading an instance of LSP (format: decrit dans le rapport)
function loadPbMCLS(fname)
  f = open(fname)
  # lecture du nbre de produits (N)
  N = parse.(Int,split(readline(f)))
  # lecture du nbre de périodes (T)
  T = parse.(Int,split(readline(f)))
  N = N[1]
  T = T[1]
  # Les valeurs des coûts ne dependent que de T

  # lecture des coûts P[i,t]
  P = zeros(N,T)
  t = 1
  for value in split(readline(f))
    valeur = parse(Float64,value)
    for i = 1:N
      P[i,t] = valeur
    end
    t+=1
  end

  # lecture des coûts F[i,t]
  F = zeros(N,T)
  t = 1
  for value in split(readline(f))
    valeur = parse(Float64,value)
    for i = 1:N
      F[i,t] = valeur
    end
    t+=1
  end

  # lecture des coûts H[i,t]
  H = zeros(N,T)
  t = 1
  for value in split(readline(f))
    valeur = parse(Float64,value)
    for i = 1:N
      H[i,t] = valeur
    end
    t+=1
  end

  D = zeros(N,T)
  # lecture des demandes D[i,t]
  i = 1
  t = 1
  for value in split(readline(f))
    valeur = parse(Float64,value)
    D[i,t] = valeur
    if t == T
      i+=1
      t = 0
    end
    t+=1
  end

  C = zeros(T)
  # lecture des capacités C[t]
  for value in split(readline(f))
      valeur = parse(Float64,value)
      C[t] = valeur
      t+=1
  end

  # lecture des coût de penalité B[i,t]
  B = zeros(N,T)
  t = 1
  for value in split(readline(f))
    valeur = parse(Float64,value)
    for i = 1:N
      B[i,t] = valeur
    end
    t+=1
  end
  close(f)
  return P,F,H,D,C,B
end

function loadPb(fname)
f = open(fname)
# lecture du nbre de périodes (T)
T = parse.(Int,split(readline(f)))
T = T[1]
# lecture des coûts P[t]
P = zeros(T)
t = 1
for value in split(readline(f))
  valeur = parse(Float64,value)
  P[t] = valeur
  t+=1
end

# lecture des coûts F[t]
F = zeros(T)
t = 1
for value in split(readline(f))
  valeur = parse(Float64,value)
  F[t] = valeur
  t+=1
end

# lecture des coûts H[t]
H = zeros(T)
t = 1
for value in split(readline(f))
  valeur = parse(Float64,value)
  H[t] = valeur
  t+=1
end

D = zeros(T)
# lecture des demandes D[t]
t = 1
for value in split(readline(f))
  valeur = parse(Float64,value)
  D[t] = valeur
  t+=1
end
close(f)
return P,F,H,D
end
