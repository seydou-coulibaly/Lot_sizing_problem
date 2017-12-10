# --------------------------------------------------------------------------- #

# Definition Type Noeud
type Node
  num::Int
  Y::Array{Int64,2}
end

# Banch and bound algorithm
function resolutionMultiProduit(solverSelected,D,P,H,F,B,C,M,V,PHI)
  # INIT
  N,T = size(D)
  #
  # ---------------------------------------------------------------------------
  # Borne primale : fixer tous les Y[i,t] à 1
  Contraintes = ones(Int,N,T)
  ip,zx,zy,zs,zr =  setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI,B,Contraintes)
  solve(ip)
  bornePrimale = getobjectivevalue(ip)
  zx = getvalue(zx)
  zy = getvalue(zy)
  zs = getvalue(zs)
  zr = getvalue(zr)
  #  --------------------------------------------------------------------------
  # Borne duale
  Contraintes = fill(2,N,T)
  ip,x,y,s,r =  setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI,B,Contraintes)
  solve(ip)
  borneDuale = getobjectivevalue(ip)
  # ---------------------------------------------------------------------------
  println("")
  println("Borne primale  = ", bornePrimale)
  println("Borne duale    = ", borneDuale)
  println("------------------------ Log -------------------------------------")


  listeNoeud = Node[]
  number = 0
  init = Node(number,Contraintes)
  push!(listeNoeud,init)

  while length(listeNoeud) > 0
    # Brancher sur le premier noeud de la liste
    noeudCourant = shift!(listeNoeud)
    # print("\n--------------------  Noeud ",noeudCourant.num); println(" --------------------")
    # println(noeudCourant.Y)
    ip,x,y,s,r =  setMCLSP(solverSelected,D,V,C,P,F,H,M,PHI,B,noeudCourant.Y)
    status = solve(ip)

    if status != :Infeasible
      z = getobjectivevalue(ip)
      # println("Valeur de Z = ",z)
      if z < bornePrimale
        x = getvalue(x)
        y = getvalue(y)
        s = getvalue(s)
        r = getvalue(r)
        #si solution est entiere, faire mis a jour
        verif = true
        for i=1:N
          for t=1:T
            verif = verif && isinteger(y[i,t])
          end
        end
        if verif
          #tous les solutions sont donc entières, noeud sondé
          # println("Noeud sondé : solution entière")
          zx,zy,zs = x,y,s
          # println("x  = ",zx);
          # println("y  = ",zy);
          # println("s  = ",zs);
          # println("r  = ",zr);
          bornePrimale = z
        else
          # separer le noeud
          verif = 2 in noeudCourant.Y
          if verif
            indL = findfirst(noeudCourant.Y,2)
            indL = indL % N
            if indL == 0
              indL = N
            end
            indC = findfirst(noeudCourant.Y[indL,:],2)
            # fils droit
            fdContrainte = copy(noeudCourant.Y)
            fdContrainte[indL,indC] = 1
            fdIndice = number+2
            fd = Node(fdIndice,fdContrainte)
            # Inserer Au debut de la liste
            unshift!(listeNoeud,fd)
            # print("\nSeparer sur fils droit Y[",indL);print(",",indC);println("] = 1 -------  Noeud",fdIndice)
            # fils gauche
            fgContrainte = copy(noeudCourant.Y)
            fgContrainte[indL,indC] = 0
            fgIndice = number+1
            fg = Node(fgIndice,fgContrainte)
            # Inserer Au debut de la liste
            unshift!(listeNoeud,fg)
            # print("Separer sur fils gauch Y[",indL);print(",",indC);println("] = 0 -------  Noeud",fgIndice)
            number = number+2
          else
            # println("Separation effectuée sur tous les Y[i,t]")
          end
        end
      else
        # println("Noeud sondé : Une meilleure solution entière connue")
      end
    else
      # println("Noeud sondé : Infaisabilité")
    end
  end
  # Afficher la solution trouvée
  println("---------------------------------------------------")
  println("           Valeur optimale                         ")
  println("---------------------------------------------------")
  println("Zopt : ",bornePrimale)
  println("Nb noeuds : ",number)
  println("x  : ",zx);
  println("y  : ",zy);
  println("s  : ",zs);
  println("r  : ",zr);
end
