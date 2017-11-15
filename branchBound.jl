# --------------------------------------------------------------------------- #

# Banch and bound algorithm
function branchANDBound(D, P, H, F)
borneInf = 0
borneSup = 0
zEntierConnu = 0



#=
evaluation du noeud init
on suppose qu'on tombe sur une solution non entiere
i = 1
1) Du noeud init, je separe sur yi = 0 et yi = 1
2) developper quand yi vaut 0 puis quand yi vaut 1
3) bactracking si plus petit que la meilleure solution entiere connue
4) ou backtrack et momorisation si solution entière et meilleure que celle connue
5) si tous les yi sont separées, alors retourner meilleure solution obtnue
=#
end
