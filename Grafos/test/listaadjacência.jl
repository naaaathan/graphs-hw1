using Grafos.ListaAdjacências


@testset "Grafos.ListaAdjacências" begin
    g = nulo()
    @test nvértices(g) == 0
    @test narestas(g) == 0
    @test vértices(g) == []

    g = vazio(4)
    @test nvértices(g) == 4
    @test narestas(g) == 0
    @test vértices(g) == [1,2,3,4]

    g = nulo()
    novo_vértice!(g)
    novo_vértice!(g)
    @test nvértices(g) == 2
    @test narestas(g) == 0
    @test vértices(g) == [1,2]

    gc = cópia(g)
    @test nvértices(g) == nvértices(gc) == 2
    @test narestas(g) == narestas(gc) == 0
    @test vértices(g) == vértices(gc) == [1,2]

    novo_vértice!(gc)
    @test nvértices(g) == 2 && nvértices(gc) == 3
    @test vértices(gc) == [1,2,3]

    # grafo a partir de uma matriz de adjacências já existente
    gm = ListaAdjacência([ 0 1 1;
                           1 0 1;
                           1 1 0 ])
    @test nvértices(gm) == 3
    @test narestas(gm) == 3
    @test vizinhos(gm, 1) == [2,3]

    # grafo casa
    gcasa = nulo()
    novos_vértices!(gcasa, 5)
    nova_aresta!(gcasa, 1, 2)
    nova_aresta!(gcasa, 1, 3)
    nova_aresta!(gcasa, 2, 4)
    nova_aresta!(gcasa, 3, 4)
    nova_aresta!(gcasa, 3, 5)
    nova_aresta!(gcasa, 4, 5)
    @test nvértices(gcasa) == 5
    @test narestas(gcasa) == 6
    @test vizinhos(gcasa, 4) == [2,3,5]

    # grafo do exemplo 31
    g31 = ListaAdjacência([(1,4), (2,3), (2,4), (3,4), (4,5), (4,6), (5,6)])
    @test nvértices(g31) == 6
    @test narestas(g31) == 7
    @test matriz_adj(g31) == [0  0  0  1  0  0 ;
                              0  0  1  1  0  0 ;
                              0  1  0  1  0  0 ;
                              1  1  1  0  1  1 ;
                              0  0  0  1  0  1 ;
                              0  0  0  1  1  0 ]
    @test lista_adj(g31) == [ [4],
                              [3, 4],
                              [2, 4],
                              [1, 2, 3, 5, 6],
                              [4, 6],
                              [4, 5] ]

    # grafo do exemplo 33
    g33 = ListaAdjacência([(1,2), (1,3), (2,3), (3,4), (3,5)])
    @test nvértices(g33) == 5
    @test narestas(g33) == 5
    @test grau(g33, 3) == 4
    @test vizinhos(g33,3) == [1, 2, 4, 5]
    @test lista_adj(g33) == [
        [2,3],
        [1,3],
        [1,2,4,5],
        [3],
        [3] ]
    @test matriz_adj(g33) == [ 0  1  1  0  0 ;
                               1  0  1  0  0 ;
                               1  1  0  1  1 ;
                               0  0  1  0  0 ;
                               0  0  1  0  0 ]


    # grafo do exemplo 1
    vs = collect('a':'e')
    mapa, mapa_rev = gera_mapas_vértices(vs)
    ars = mapeia_arestas(mapa, [('a','b'), ('a','c'), ('a','e'), ('b','c'),
                                ('b','e'), ('c','d'), ('c','e'), ('d','e')])
    g1 = ListaAdjacência(ars)

    @test nvértices(g1) == 5
    @test narestas(g1) == 8
    @test vértices(g1) == [1,2,3,4,5]
    @test mapeia_vértices(mapa_rev, vértices(g1)) == ['a', 'b', 'c', 'd', 'e']
    @test grau(g1, 1) == 3
    @test grau(g1, mapa['a']) == 3
    @test grau(g1, mapa['c']) == 4
    @test lista_adj(g1) == [[2, 3, 5],
                            [1, 3, 5],
                            [1, 2, 4, 5],
                            [3, 5],
                            [1, 2, 3, 4]]
    @test map(la -> mapeia_vértices(mapa_rev, la), lista_adj(g1)) ==
          [ ['b', 'c', 'e'],
            ['a', 'c', 'e'],
            ['a', 'b', 'd', 'e'],
            ['c', 'e'],
            ['a', 'b', 'c', 'd']]

    @test vizinhos(g1, mapa['e']) == [1,2,3,4]
    @test mapeia_vértices(mapa_rev, vizinhos(g1, mapa['e'])) == [ 'a', 'b', 'c', 'd' ]
    @test adjacente(g1, mapa['a'], mapa['c']) == true
    @test adjacente(g1, mapa['a'], mapa['d']) == false
    @test é_vértice(g1, mapa['b']) == true
    @test é_vértice(g1, 8) == false
    @test é_aresta(g1, 5, 2) == true
    @test é_aresta(g1, mapa['e'], mapa['b']) == true
    @test é_aresta(g1, (5, 2)) == true
    @test é_aresta(g1, (mapa['e'], mapa['b'])) == true
    @test arestas(g1) == [(1, 2), (1, 3), (1, 5),  (2, 3),  (2, 5), (3, 4), (3, 5), (4, 5)]
    @test mapeia_arestas(mapa_rev,arestas(g1)) == [  ('a', 'b'), ('a', 'c'), ('a', 'e'), ('b', 'c'),
                                                     ('b', 'e'), ('c', 'd'), ('c', 'e'), ('d', 'e') ]

    g1cópia = cópia(g1)
    @test remove_vértices!(g1cópia, mapeia_vértices(mapa, ['a', 'e'])) == [2,3,4]
    @test nvértices(g1cópia) == 3
    g1cópia = cópia(g1)
    vmap = remove_vértices!(g1cópia, mapeia_vértices(mapa, ['a', 'e']))
    @test mapeia_vértices(mapa_rev, vmap) == ['b', 'c', 'd']  # vértices restantes no grafo
    @test arestas(g1cópia) == [(1,2), (2,3)]
    @test mapeia_arestas(vmap, arestas(g1cópia)) == [ (2, 3),  (3, 4)]
    @test mapeia_arestas(mapa_rev, mapeia_arestas(vmap, arestas(g1cópia))) == [('b', 'c'),  ('c', 'd')]
    @test nova_aresta!(g1cópia, 1, 3) == true
    @test nova_aresta!(g1cópia, 1, 3) == false # aresta já no grafo
end
