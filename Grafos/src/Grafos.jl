module Grafos

export 
  Grafo, ListaAdjacência,
  cópia,
  vazio, nulo, 
  lista_adj, matriz_adj,
  nvértices, vértices, grau, 
  novo_vértice!, novos_vértices!,
  vizinhos, adjacente, é_vértice, remove_vértices!, 
  narestas, é_aresta, nova_aresta!, remove_aresta!,
  mesma_aresta, arestas, seqGraus



    
include("MatrizAdjacências.jl")
import .MatrizAdjacências

include("ListaAdjacências.jl")
using .ListaAdjacências

const Grafo = Grafos.ListaAdjacências.ListaAdjacência  # tipo sinônimo

seqGraus(g::Grafo) = sort(map( v -> grau(g,v), vértices(g)))

# Trabalho 1
include("grafosEspeciais.jl")

##
g = Grafo([(1,4), (2,3), (2,4), (3,4), (4,5), (4,6), (5,6)])
sort(map( v -> grau(g,v), vértices(g)))
##

end # module
