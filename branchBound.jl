# --------------------------------------------------------------------------- #


# Definition Type Noeud
type Noeud
  num::Int
  Y::Array{Int64,1}
end


# Banch and bound algorithm
function branchANDBound(solverSelected,D,P,H,F)

  # =========================================================================== #
  # INIT
  t = length(D)
  # ---------------------------------------------------------------------------
  # Borne primale : fixer tous les Y[i] à 1
  for i=1:t
    C[i] = 1
  end
  ip,zx,zy,zs = setULP(solverSelected,D,P,H,F,C)
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
  ip,x,y,s = setULP(solverSelected,D,P,H,F,C)
  solve(ip)
  borneDuale = getobjectivevalue(ip)
  # ---------------------------------------------------------------------------
  println("")
  println("Borne primale  = ", bornePrimale)
  println("Borne duale  = ", borneDuale)


  listeNoeud = Noeud[]
  init = Noeud(1,C)
  push!(listeNoeud,init)

  while length(listeNoeud) > 0
    # Brancher sur le premier noeud de la liste
    noeudCourant = shift!(listeNoeud)
    print("\n--------------------  Noeud ",noeudCourant.num); println(" --------------------")
    println(noeudCourant.Y)
    ip,x,y,s = setULP(solverSelected,D,P,H,F,noeudCourant.Y)
    status = solve(ip)

    if status != :Infeasible
      z = getobjectivevalue(ip)
      if z < bornePrimale
        x = getvalue(x)
        y = getvalue(y)
        s = getvalue(s)
        #si solution est entiere, faire mis a jour
        verif = true
        for i=1:t
          verif = verif && isinteger(x[i])
        end
        if verif
          #tous les solutions sont donc entières, noeud sondé
          println("Noeud sondé : solution entière")
          zx,zy,zs = x,y,s
          println("z = ",z)
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
            fd = Noeud((noeudCourant.num+2),fdContrainte)
            unshift!(listeNoeud,fd)
            print("\nSeparer sur fils droit Y[",indice);println("] = 1 -------",(noeudCourant.num+2))
            # fils gauche
            fgContrainte = copy(noeudCourant.Y)
            fgContrainte[indice] = 0
            fg = Noeud((noeudCourant.num+1),fgContrainte)
            unshift!(listeNoeud,fg)
            print("Separer sur fils gauch Y[",indice);println("] = 0 -------",(noeudCourant.num+1))
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
