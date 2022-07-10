module MatrizAdjacências

# Adaptado de https://github.com/JuliaGraphs/Graphs.jl/blob/master/src/SimpleGraphs/simplegraph.jl

export MatrizAdjacência,
    cópia,
    vazio,
    nulo,
    matriz_adj,
    lista_adj,
    nvértices,
    vértices,
    grau,
    novo_vértice!,
    novos_vértices!,
    vizinhos,
    adjacente,
    é_vértice,
    remove_vértices!,
    narestas,
    é_aresta,
    nova_aresta!,
    remove_aresta!,
    mesma_aresta,
    arestas


mutable struct MatrizAdjacência
    n::Int64 # número de vértices
    m::Int64 # número de arestas
    mat::Matrix{Int64}
end


"""
    MatrizAdjacência(lista_arestas::Vector)

Constrói um grafo a partir de um vetor de arestas.
O número de vértices do grafo será o maior de um
vértice que seja ponta de uma aresta em `lista_arestas`.
"""
function MatrizAdjacência(lista_arestas::Vector{Tuple{Int64,Int64}})
    numv = 0
    for (u, v) in lista_arestas
        numv = max(numv, u, v)
    end

    mat = zeros(Int64, numv, numv)
    m = 0
    for (u, v) in lista_arestas
        (u >= 1 && v >= 1) || continue
        mat[u, v] = 1
        mat[v, u] = 1
        m += 1
    end

    g = nulo()
    g.m = m
    g.n = numv
    g.mat = mat

    return g
end



"""
    MatrizAdjacência(matriz_adj)

Constrói um grafo a partir de uma matriz de adjacências do tipo Matrix{Int64}.
Note que esta matriz deve ser uma matriz de 0's e 1's, simétrica e quadrada
de ordem n, com n sendo o número de vértices do grafo.
"""
function MatrizAdjacência(matriz_adj::Matrix{Int64})
    n = size(matriz_adj, 1)

    size(matriz_adj, 2) == n ||
        throw(ArgumentError("MatrizAdjacência: a matriz deve ser quadrada"))


    mat = zeros(Int64, n, n)
    m = 0
    for u = 1:n
        for v = u:n
            if matriz_adj[u, v] > 0
                mat[u, v] = 1
                mat[v, u] = 1
                m += 1
            end
        end
    end

    g = nulo()
    g.m = m
    g.n = n
    g.mat = mat

    return g
end




"""
    vazio(n)

Retorna um grafo vazio com n vértices.
"""
vazio(n::Int64)::MatrizAdjacência = MatrizAdjacência(n, 0, zeros(Int64, n, n))


"""
    nulo()

Retorna um grafo nulo.
"""
nulo()::MatrizAdjacência = MatrizAdjacência(0, 0, Array{Int64}(undef, 0, 0))


"""
    cópia(g::MatrizAdjacência)

Devolve uma cópia de g.
"""
cópia(g::MatrizAdjacência)::MatrizAdjacência =
    MatrizAdjacência(g.n, g.m, copy(g.mat))


"""
    matriz_adj(g)

Devolve a matriz de adjacência de `g`.
"""
matriz_adj(g::MatrizAdjacência) = deepcopy(g.mat)


"""
    matriz_adj(g)

Devolve a lista de adjacências de `g`.
"""
function lista_adj(g::MatrizAdjacência)
    n = g.n
    m = g.m
    mat = g.mat

    lista_adj = Vector{Vector{Int64}}(undef, n)
    for v = 1:n
        lista_adj[v] = vizinhos(g, v)
    end
    return lista_adj
end



"""
    nvértices(g)

Devolve o número de vértices de `g`.
"""
nvértices(g::MatrizAdjacência) = g.n


"""
    vértices(g)

Devolve a lista de vértices de `g`.
"""
vértices(g::MatrizAdjacência) = collect(1:nvértices(g))


"""
    grau(g,v)

Devolve o grau do vértice `v` em `g`
"""
function grau(g::MatrizAdjacência, v::Integer)
    (1 <= v <= nvértices(g)) || throw(
        ArgumentError(
            "grau: os vértices devem estar no intervalo 1:nvértices(g).",
        ),
    )
    return sum(g.mat[:, v])
end


"""
    novo_vértice!(g)

Adiciona um novo vértice ao grafo `g`.
"""
function novo_vértice!(g::MatrizAdjacência)
    n = g.n + 1
    mat = zeros(Int64, n, n)
    mat[1:g.n, 1:g.n] = g.mat
    g.n = n
    g.mat = mat
end

"""
    novos_vértices!(g,n)

Adiciona n novos vértices ao grafo `g`.
"""
function novos_vértices!(g::MatrizAdjacência, n::Integer)
    nv = g.n + n
    mat = zeros(Int64, nv, nv)
    mat[1:g.n, 1:g.n] = g.mat
    g.n = nv
    g.mat = mat
end


"""
    vizinhos(g,v)

Devolve a lista de vértices vizinhos de `v` em `g`
"""
vizinhos(g::MatrizAdjacência, v::Integer) =
    [idx for (idx, v) in enumerate(g.mat[:, v]) if v != 0]



"""
    adjacente(g,u,v)

Devolve `true` se o vértice `u` for adjacente a `v` em `g`
"""
adjacente(g::MatrizAdjacência, u::Integer, v::Integer) = g.mat[u, v] == 1


"""
    é_vértice(g,v)

Devolve `true` se `v` for um vértice de `g`
"""
é_vértice(g::MatrizAdjacência, v::Integer) = v in vértices(g)


"""
    remove_vértices!(g, vs) -> vmap

Remove todos os vértices em `vs` de `g`.
Devolve um vetor `vmap` que mapeia os vértices no grafo modificado para
aqueles do grafo inicial.
"""
function remove_vértices!(g::MatrizAdjacência, vs::Vector{Int64})
    n = nvértices(g)
    isempty(vs) && return collect(1:n)

    # Ordena e filtra os vértices a serem removidos
    remove = sort(vs)
    unique!(remove)
    (1 <= remove[1] && remove[end] <= n) || throw(
        ArgumentError(
            "Vértices a serem removidos devem estar no intervalo 1:nvértices(g).",
        ),
    )

    # Cria um vmap que mapeia vértices para suas novas posições.
    # Vértices a serem removidos são mapeados para 0
    vmap = Vector{Int64}(undef, n)

    # Percorre a lista de vértices e desloca se for um vértice a ser removido
    i = 1
    for u in vértices(g)
        if i <= length(remove) && u == remove[i]
            vmap[u] = 0
            i += 1
        else
            vmap[u] = u - (i - 1)
        end
    end


    # Conta o número de arestas que serão removidas.
    # Para uma aresta que será removida, temos que assegurar
    # que tal aresta não é contada duas vezes quando ambas
    # de suas pontas forem removidas.
    n_arestas_removidas = 0
    for u in remove
        for v in vizinhos(g, u)
            if v >= u || vmap[v] != 0
                n_arestas_removidas += 1
            end
        end
    end

    mat = g.mat

    n1 = n - length(remove)
    matnova = zeros(Int64, n1, n1)

    # Mova as colunas na matriz de adjacência para suas novas posições.
    for u = 1:n
        if vmap[u] != 0
            for v = 1:n
                if vmap[v] != 0
                    matnova[vmap[u], vmap[v]] = mat[u, v]
                end
            end
        end
    end

    g.n = n1
    g.m -= n_arestas_removidas
    g.mat = matnova


    # Criaremos um vmap reverso, que mapeia vértices no grafo resultante
    # para aqueles do grafo original.
    vmap_reverso = Vector{Int64}(undef, nvértices(g))
    for (i, u) in enumerate(vmap)
        if u != 0
            vmap_reverso[u] = i
        end
    end

    return vmap_reverso
end



## Operações sobre arestas

"""
    narestas(g)

Devolve o número de arestas do grafo `g`
"""
narestas(g::MatrizAdjacência) = g.m


"""
    é_aresta(g, u, v)

Devolve `true` se `(u,v)` for uma aresta de `g`
"""
é_aresta(g::MatrizAdjacência, u::Integer, v::Integer) = g.mat[u, v] == 1
é_aresta(g::MatrizAdjacência, (u, v)) = g.mat[u, v] == 1


"""
    nova_aresta!(g,u,v)

Adiciona uma nova aresta `(u,v)` ao grafo `g`. Devolve `true` se a adição foi
bem sucedida, ou `false` em caso contrário. As pontas das arestas já devem existir
no grafo.
"""
function nova_aresta!(g::MatrizAdjacência, u, v)
    vs = vértices(g)
    (u in vs && v in vs) || return false    # alguma ponta não está no grafo
    g.mat[u, v] == 0 || return false         # aresta já no grafo

    g.mat[u, v] = 1
    g.mat[v, u] = 1

    g.m += 1
    return true     # aresta adicionada com sucesso
end


nova_aresta!(g::MatrizAdjacência, (u, v)) = nova_aresta!(g, u, v)


"""
    remove_aresta!(g,u,v)

Remove uma nova `(u,v)` do grafo `g`. Devolve `true` se a remoção foi
bem sucedida, ou `false` em caso contrário. As pontas das arestas já
devem existir no grafo.
"""
function remove_aresta!(g::MatrizAdjacência, u, v)
    vs = vértices(g)
    (u in vs && v in vs) || return false    # alguma ponta não está no grafo
    g.mat[u, v] == 0 || return false # aresta fora do grafo

    g.mat[u, v] = 0
    g.mat[v, u] = 0

    g.m -= 1
    return true     # aresta removida com sucesso
end

remove_aresta!(g::MatrizAdjacência, (u, v)) =
    remove_aresta!(g::MatrizAdjacência, u, v)


mesma_aresta((t, u), (v, w)) = (t, u) == (v, w) || (u, t) == (v, w)


"""
    arestas(g)

Devolve a lista de arestas do grafo `g`
"""
function arestas(g::MatrizAdjacência)
    lista_arestas = Vector{Tuple{Int64,Int64}}()
    n = nvértices(g)
    mat = g.mat
    for u = 1:n
        for v = u:n
            if mat[u, v] == 1
                push!(lista_arestas, (u, v))
            end
        end
    end
    return lista_arestas
end

#=
g = nulo()
novo_vértice!(g) # 1
novo_vértice!(g) # 2
novo_vértice!(g) # 3
novo_vértice!(g) # 4
novo_vértice!(g) # 5
nova_aresta!(g,1,2)
nova_aresta!(g,1,3)
nova_aresta!(g,2,4)
nova_aresta!(g,3,4)
nova_aresta!(g,4,5)

g2 = cópia(g)  # cópia de g
remove_aresta!(g2, 4, 5)

g3 = MatrizAdjacência([(1,2), (1,3), (2,4), (3,4), (4,5)])
remove_vértices!(g3, [4])

nvértices(g)   # 5 vértices
vértices(g)   # [1,2,3,4,5]
=#

end # module
