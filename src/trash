# --------------------------------------------------------------------------- #
# Definition Type Noeud
type Noeud
  num::Int
  Y::Array{Int64,1}
end

# Banch and bound algorithm

function branchANDBoundsetMCLSP(solverSelected,D,P,H,F,B,C,M,V,PHI)
  # INIT
  N,T = size(D)
  N = 4
  T = 4
  X = zeros(Int,N,T)
  Y = zeros(Int,N,T)
  S = zeros(Int,N,T)
  R = zeros(Int,N,T)
  Z = 0
  for i=1:N
    z,zx,zy,zs,zr = miniBranchANDBound(solverSelected,D[i,:],P[i,:],H[i,:],F[i,:],B[i,:],C,M[i,:],V[i,:],PHI[i,:])
  end
  println("Somme = ",somme)
end

# =====================================================================================================================================
#       MINI BRANCH AND BOUND
# =====================================================================================================================================


# Mini Banch and bound algorithm sur les produits deja connus
function miniBranchANDBound(solverSelected,D,P,H,F,B,C,M,V,PHI)

  # =========================================================================== #
  # INIT
  t = length(D)
  t = 4
  # ---------------------------------------------------------------------------
  # Borne primale : fixer tous les Y[i] à 1
  Contraintes = ones(Int,t)
  println(Contraintes)
  ip,zx,zy,zs,zr = setminLP(solverSelected,D,P,H,F,B,C,M,V,PHI,Contraintes)
  solve(ip)
  bornePrimale = getobjectivevalue(ip)
  zx = getvalue(zx)
  zy = getvalue(zy)
  zs = getvalue(zs)
  zr = getvalue(zr)
  #  --------------------------------------------------------------------------
  # Borne duale
  Contraintes = fill(2,t)
  ip,x,y,s,r = setminLP(solverSelected,D,P,H,F,B,C,M,V,PHI,Contraintes)
  solve(ip)
  borneDuale = getobjectivevalue(ip)
  # ---------------------------------------------------------------------------
  println("")
  println("Borne primale  = ", bornePrimale)
  println("Borne duale  = ", borneDuale)


  listeNoeud = Noeud[]
  number = 0
  init = Noeud(number,Contraintes)
  push!(listeNoeud,init)

  while length(listeNoeud) > 0
    # Brancher sur le premier noeud de la liste
    noeudCourant = shift!(listeNoeud)
    print("\n--------------------  Noeud ",noeudCourant.num); println(" --------------------")
    println(noeudCourant.Y)
    ip,x,y,s,r = setminLP(solverSelected,D,P,H,F,B,C,M,V,PHI,noeudCourant.Y)
    status = solve(ip)

    if status != :Infeasible
      z = getobjectivevalue(ip)
      println("Valeur de Z = ",z)
      if z < bornePrimale
        x = getvalue(x)
        y = getvalue(y)
        s = getvalue(s)
        r = getvalue(r)
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
          println("r  = ",zr);
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
  println("r  = ",zr);
  return bornePrimale,zx,zy,zs,zr
end
