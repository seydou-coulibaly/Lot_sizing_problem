# --------------------------------------------------------------------------- #


# Definition Type Noeud
type Noeud
  num::Int
  Y::Array{Int64,1}
end


# Banch and bound algorithm
function branchANDBound(solverSelected,D,P,H,F,M)

  # =========================================================================== #
  # INIT
  t = length(D)
  # ---------------------------------------------------------------------------
  # Borne primale : fixer tous les Y[i] à 1
  C = zeros(Int,t)
  for i=1:t
    C[i] = 1
  end
  ip,zx,zy,zs = setULPLP(solverSelected,D,P,H,F,M,C)
  #ip,zx,zy,zs = model3(solverSelectedLP,D,P,H,F,M,C)
  solve(ip)
  bornePrimale = getobjectivevalue(ip)
  zx = getvalue(zx)
  zy = getvalue(zy)
  zs = getvalue(zs)
  #  --------------------------------------------------------------------------
  # Borne duale
  for i=1:t
    C[i] = 2
  end
  ip,x,y,s = setULPLP(solverSelected,D,P,H,F,M,C)
  #ip,x,y,s = model3(solverSelectedLP,D,P,H,F,M,C)
  solve(ip)
  borneDuale = getobjectivevalue(ip)
  # ---------------------------------------------------------------------------
  println("")
  println("Borne primale  = ", bornePrimale)
  println("Borne duale  = ", borneDuale)


  listeNoeud = Noeud[]
  number = 0
  init = Noeud(number,C)
  push!(listeNoeud,init)

  while length(listeNoeud) > 0
    # Brancher sur le premier noeud de la liste
    noeudCourant = shift!(listeNoeud)
    print("\n--------------------  Noeud ",noeudCourant.num); println(" --------------------")
    println(noeudCourant.Y)
    ip,x,y,s = setULPLP(solverSelected,D,P,H,F,M,noeudCourant.Y)
    #ip,x,y,s = model3(solverSelectedLP,D,P,H,F,M,noeudCourant.Y)
    status = solve(ip)

    if status != :Infeasible
      z = getobjectivevalue(ip)
      println("Valeur de Z = ",z)
      if z < bornePrimale
        x = getvalue(x)
        y = getvalue(y)
        s = getvalue(s)
        #si solution est entiere, faire mis a jour
        verif = true
        for i=1:t
          verif = verif && isinteger(y[i])
        end
        if verif
          #tous les solutions sont donc entières, noeud sondé
          println("Noeud sondé : solution entière")
          zx,zy,zs = x,y,s
          println("x  = ",zx);
          println("y  = ",zy);
          println("s  = ",zs);
          bornePrimale = z
        else
          # separer le noeud
          verif = 2 in noeudCourant.Y
          if verif
            indice = findfirst(noeudCourant.Y,2)
            # fils droit
            fdContrainte = copy(noeudCourant.Y)
            fdContrainte[indice] = 1
            fdIndice = number+2
            fd = Noeud(fdIndice,fdContrainte)
            # Inserer Au debut de la liste
            unshift!(listeNoeud,fd)
            print("\nSeparer sur fils droit Y[",indice);println("] = 1 -------  Noeud",fdIndice)
            # fils gauche
            fgContrainte = copy(noeudCourant.Y)
            fgContrainte[indice] = 0
            fgIndice = number+1
            fg = Noeud(fgIndice,fgContrainte)
            # Inserer Au debut de la liste
            unshift!(listeNoeud,fg)
            print("Separer sur fils gauch Y[",indice);println("] = 0 -------  Noeud",fgIndice)
            number = number+2
          else
            println("Separation effectuée sur tous les Y[i]")
          end
        end
      else
        println("Noeud sondé : Une meilleure solution entière connue")
      end
    else
      println("Noeud sondé : Infaisabilité")
    end
  end
  # Afficher la solution trouvée
  println("---------------------------------------------------")
  println("           Valeur optimale                         ")
  println("---------------------------------------------------")
  println("BornePrimale = ",bornePrimale)
  println("x  = ",zx);
  println("y  = ",zy);
  println("s  = ",zs);
end

function separationProblemConstraint(X,Y,i,t)
  sum(min(X[i],diL*Y[i]) for i=1:l,diL=sum(X[k] for k=i:l)) # < sum(D[k] for k=1:l)
end
