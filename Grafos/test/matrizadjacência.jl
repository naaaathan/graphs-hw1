import Grafos.MatrizAdjacências as M

@testset "Grafos.MatrizAdjacências" begin
    g = M.nulo()
    @test M.nvértices(g) == 0
    @test M.narestas(g) == 0
    @test M.vértices(g) == []

    g = M.vazio(4)
    @test M.nvértices(g) == 4
    @test M.narestas(g) == 0
    @test M.vértices(g) == [1,2,3,4]

    g = M.nulo()
    M.novo_vértice!(g)
    M.novo_vértice!(g)
    @test M.nvértices(g) == 2
    @test M.narestas(g) == 0
    @test M.vértices(g) == [1,2]

    gc = M.cópia(g)
    @test M.nvértices(g) == M.nvértices(gc) == 2
    @test M.narestas(g) == M.narestas(gc) == 0
    @test M.vértices(g) == M.vértices(gc) == [1,2]

    M.novo_vértice!(gc)
    @test M.nvértices(g) == 2 && M.nvértices(gc) == 3
    @test M.vértices(gc) == [1,2,3]


    # grafo a partir de uma matriz de adjacências já existente
    gm = M.MatrizAdjacência([ 0 1 1;
                       1 0 1;
                       1 1 0 ])
    @test M.nvértices(gm) == 3
    @test M.narestas(gm) == 3
    @test M.vizinhos(gm, 1) == [2,3]

    # grafo casa
    gcasa = M.nulo()
    M.novos_vértices!(gcasa, 5)
    M.nova_aresta!(gcasa, 1, 2)
    M.nova_aresta!(gcasa, 1, 3)
    M.nova_aresta!(gcasa, 2, 4)
    M.nova_aresta!(gcasa, 3, 4)
    M.nova_aresta!(gcasa, 3, 5)
    M.nova_aresta!(gcasa, 4, 5)
    @test M.nvértices(gcasa) == 5
    @test M.narestas(gcasa) == 6
    @test M.vizinhos(gcasa, 4) == [2,3,5]


    # grafo do exemplo 31
    g31 = M.MatrizAdjacência([(1,4), (2,3), (2,4), (3,4), (4,5), (4,6), (5,6)])
    @test M.nvértices(g31) == 6
    @test M.narestas(g31) == 7
    @test M.matriz_adj(g31) == [0  0  0  1  0  0 ;
                                0  0  1  1  0  0 ;
                                0  1  0  1  0  0 ;
                                1  1  1  0  1  1 ;
                                0  0  0  1  0  1 ;
                                0  0  0  1  1  0 ]
    @test M.lista_adj(g31) == [ [4],
                                [3, 4],
                                [2, 4],
                                [1, 2, 3, 5, 6],
                                [4, 6],
                                [4, 5] ]

    # grafo do exemplo 33
    g33 = M.MatrizAdjacência([(1,2), (1,3), (2,3), (3,4), (3,5)])
    @test M.nvértices(g33) == 5
    @test M.narestas(g33) == 5
    @test M.grau(g33, 3) == 4
    @test M.vizinhos(g33,3) == [1, 2, 4, 5]
    @test M.lista_adj(g33) == [
        [2,3],
        [1,3],
        [1,2,4,5],
        [3],
        [3] ]
    @test M.matriz_adj(g33) == [ 0  1  1  0  0 ;
                                 1  0  1  0  0 ;
                                 1  1  0  1  1 ;
                                 0  0  1  0  0 ;
                                 0  0  1  0  0 ]

    # grafo do exemplo 1
    vs = collect('a':'e')
    mapa, mapa_rev = gera_mapas_vértices(vs)
    ars = mapeia_arestas(mapa, [('a','b'), ('a','c'), ('a','e'), ('b','c'),
                                ('b','e'), ('c','d'), ('c','e'), ('d','e')])
    g1 = M.MatrizAdjacência(ars)

    @test M.nvértices(g1) == 5
    @test M.narestas(g1) == 8
    @test M.vértices(g1) == [1,2,3,4,5]
    @test mapeia_vértices(mapa_rev, M.vértices(g1)) == ['a', 'b', 'c', 'd', 'e']
    @test M.grau(g1, 1) == 3
    @test M.grau(g1, mapa['a']) == 3
    @test M.grau(g1, mapa['c']) == 4
    @test M.lista_adj(g1) == [[2, 3, 5],
                              [1, 3, 5],
                              [1, 2, 4, 5],
                              [3, 5],
                              [1, 2, 3, 4]]
    @test map(la -> mapeia_vértices(mapa_rev, la), M.lista_adj(g1)) ==
          [ ['b', 'c', 'e'],
            ['a', 'c', 'e'],
            ['a', 'b', 'd', 'e'],
            ['c', 'e'],
            ['a', 'b', 'c', 'd']]

    @test M.vizinhos(g1, mapa['e']) == [1,2,3,4]
    @test mapeia_vértices(mapa_rev, M.vizinhos(g1, mapa['e'])) == [ 'a', 'b', 'c', 'd' ]
    @test M.adjacente(g1, mapa['a'], mapa['c']) == true
    @test M.adjacente(g1, mapa['a'], mapa['d']) == false
    @test M.é_vértice(g1, mapa['b']) == true
    @test M.é_vértice(g1, 8) == false
    @test M.é_aresta(g1, 5, 2) == true
    @test M.é_aresta(g1, mapa['e'], mapa['b']) == true
    @test M.é_aresta(g1, (5, 2)) == true
    @test M.é_aresta(g1, (mapa['e'], mapa['b'])) == true
    @test M.arestas(g1) == [(1, 2), (1, 3), (1, 5),
                            (2, 3),  (2, 5),
                            (3, 4), (3, 5), (4, 5)]
    @test mapeia_arestas(mapa_rev, M.arestas(g1)) ==
        [  ('a', 'b'), ('a', 'c'), ('a', 'e'), ('b', 'c'),
           ('b', 'e'), ('c', 'd'), ('c', 'e'), ('d', 'e') ]

    g1cópia = M.cópia(g1)
    @test M.remove_vértices!(g1cópia, mapeia_vértices(mapa, ['a', 'e'])) == [2,3,4]
    @test M.nvértices(g1cópia) == 3
    g1cópia = M.cópia(g1)
    vmap = M.remove_vértices!(g1cópia, mapeia_vértices(mapa, ['a', 'e']))
    @test mapeia_vértices(mapa_rev, vmap) == ['b', 'c', 'd']  # M.vértices restantes no grafo
    @test M.arestas(g1cópia) == [(1,2), (2,3)]
    @test mapeia_arestas(vmap, M.arestas(g1cópia)) == [ (2, 3),  (3, 4)]
    @test mapeia_arestas(mapa_rev, mapeia_arestas(vmap, M.arestas(g1cópia))) ==
          [('b', 'c'),  ('c', 'd')]
    @test M.nova_aresta!(g1cópia, 1, 3) == true
    @test M.nova_aresta!(g1cópia, 1, 3) == false # aresta já no grafo
end
