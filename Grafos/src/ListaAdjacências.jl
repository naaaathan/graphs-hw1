module ListaAdjacências

# Adaptado de https://github.com/JuliaGraphs/Graphs.jl/blob/master/src/SimpleGraphs/simplegraph.jl

export ListaAdjacência, cópia, vazio, nulo, lista_adj, matriz_adj,
    nvértices, vértices, grau, novo_vértice!, novos_vértices!,
    vizinhos, adjacente, é_vértice,
    remove_vértices!, narestas, é_aresta, nova_aresta!, remove_aresta!,
    mesma_aresta, arestas

abstract type GrafoAbstrato end

struct ErroNãoImplementado{M} <: Exception
    m::M
    ErroNãoImplementado(m::M) where {M} = new{M}(m)
end

Base.showerror(io::IO, ei::ErroNãoImplementado) = print(io, "método $(ei.m) não implementado")

_NI(m) = throw(ErroNãoImplementado(m))


mutable struct ListaAdjacência
    m::Int64 # número de arestas
    lista_adj::Vector{Vector{Int64}} # [fnt]: (dst,dst, ..., dst)
end


function limpa_arestas!(lista_arestas::Vector{Vector{Int64}})
    m = 0
    for v in 1:length(lista_arestas)
        if !issorted(lista_arestas[v])
            sort!(lista_arestas[v])
        end
        unique!(lista_arestas[v])
        m += length(lista_arestas[v])
        # laços contam como uma única aresta
        for w in lista_arestas[v]
            if w == v
                m += 1
                break
            end
        end
    end
    return m ÷ 2
end


"""
    ListaAdjacência(lista_arestas::Vector)

Constrói um grafo a partir de um vetor de arestas.
O número de vértices do grafo será o maior de um
vértice que seja ponta de uma aresta em `lista_aresta`.
"""
function ListaAdjacência(lista_arestas::Vector{Tuple{Int64,Int64}})
    numv = 0
    for (u,v) in lista_arestas
        numv = max(numv, u, v)
    end

    tamanhos_de_listas = ones(Int, numv)
    graus = zeros(Int, numv)
    for (u,v) in lista_arestas
        (u >= 1 && v >= 1) || continue
        graus[u] += 1
        if u != v
            graus[v] += 1
        end
    end

    lista_adj = Vector{Vector{Int64}}(undef, numv)
    for v in 1:numv
        lista_adj[v] = Vector{Int64}(undef, graus[v])
    end

    for (u,v) in lista_arestas
        (u >= 1 && v >= 1) || continue
        lista_adj[u][tamanhos_de_listas[u]] = v
        tamanhos_de_listas[u] += 1
        if u != v
            lista_adj[v][tamanhos_de_listas[v]] = u
            tamanhos_de_listas[v] += 1
        end
    end

    m = limpa_arestas!(lista_adj)
    g = nulo()
    g.lista_adj = lista_adj
    g.m = m

    return g
end


"""
    ListaAdjacência(matriz_adj)

Constrói um grafo a partir de uma matriz de adjacências do tipo Matrix{Int64}.
Note que esta matriz deve ser uma matriz de 0's e 1's, simétrica e quadrada
de ordem n, com n sendo o número de vértices do grafo.
"""
function ListaAdjacência(matriz_adj::Matrix{Int64})
    n = size(matriz_adj, 1)

    size(matriz_adj,2) == n ||
         throw(ArgumentError("ListaAdjacência: a matriz deve ser quadrada"))

    tamanhos_de_listas = ones(Int, n)
    graus = zeros(Int, n)
    for u in 1:n
        for v in u+1:n
            if matriz_adj[u,v] == 1
                graus[u] += 1
                graus[v] += 1
            end
        end
    end

    lista_adj = Vector{Vector{Int64}}(undef, n)
    for v in 1:n
        lista_adj[v] = Vector{Int64}(undef, graus[v])
    end

    for u in 1:n, v in u+1:n
        lista_adj[u][tamanhos_de_listas[u]] = v
        tamanhos_de_listas[u] += 1
        if u != v
            lista_adj[v][tamanhos_de_listas[v]] = u
            tamanhos_de_listas[v] += 1
        end
    end

    m = limpa_arestas!(lista_adj)
    g = nulo()
    g.lista_adj = lista_adj
    g.m = m

    return g
end


"""
    cópia(g::ListaAdjacência)

Devolve uma cópia de g.
"""
cópia(g::ListaAdjacência)::ListaAdjacência = ListaAdjacência(g.m, deepcopy(g.lista_adj))

"""
    vazio(n)

Retorna um grafo vazio com n vértices
"""
vazio(n::Int64)::ListaAdjacência = ListaAdjacência(0, [Vector{Int64}() for _ in 1:n])

"""
    nulo()

Retorna um grafo nulo
"""
nulo()::ListaAdjacência =  ListaAdjacência(0, Vector{Vector{Int64}}())


"""
    lista_adj(g)

Devolve a lista de adjacência de `g`
"""
lista_adj(g::ListaAdjacência) = deepcopy(g.lista_adj)



"""
    matriz_adj(g)

Devolve a matriz de adjacência de `g`
"""
function matriz_adj(g::ListaAdjacência)
    n = nvértices(g)
    mat = zeros(Int64, n, n)

    for (u,v) in arestas(g)
        mat[u,v] = 1
        mat[v,u] = 1
    end
    return mat
end


## Operações sobre vértices


"""
    nvértices(g)

Devolve o número de vértices de `g`.
"""
nvértices(g::ListaAdjacência) = length(g.lista_adj)


"""
    vértices(g)

Devolve a lista de vértices de `g`.
"""
vértices(g::ListaAdjacência) = collect(1:nvértices(g))


"""
    grau(g,v)

Devolve o grau do vértice `v` em `g`
"""
function grau(g::ListaAdjacência, v::Integer)
  (1 <= v <= nvértices(g)) ||
      throw(ArgumentError("grau: os vértices devem estar no intervalo 1:nvértices(g)."))
  return length(g.lista_adj[v])
end

"""
    novo_vértice!(g)

Adiciona um novo vértice ao grafo `g`.
"""
novo_vértice!(g::ListaAdjacência) = push!(g.lista_adj, Vector{Int64}())


"""
    novos_vértices!(g,n)

Adiciona n novos vértices ao grafo `g`.
"""
novos_vértices!(g::ListaAdjacência, n::Integer) = sum([novo_vértice!(g) for i = 1:n])



"""
    vizinhos(g,v)

Devolve a lista de vértices vizinhos de `v` em `g`
"""
vizinhos(g::ListaAdjacência, v::Integer) = g.lista_adj[v]

"""
    adjacente(g,u,v)

Devolve `true` se o vértice `u` for adjacente a `v` em `g`
"""
adjacente(g::ListaAdjacência, u::Integer, v::Integer) = u in g.lista_adj[v]


"""
    é_vértice(g,v)

Devolve `true` se `v` for um vértice de `g`
"""
é_vértice(g::ListaAdjacência, v::Integer) = v in vértices(g)


"""
    remove_vértices!(g, vs) -> vmap

Remove todos os vértices em `vs` de `g`.
Devolve um vetor `vmap` que mapeia os vértices no grafo modificado para
aqueles do grafo inicial.
"""
function remove_vértices!(g::ListaAdjacência, vs::Vector{Int64})
    n = nvértices(g)
    isempty(vs) && return collect(1:n)

    # Ordena e filtra os vértices a serem removidos
    remove = sort(vs)
    unique!(remove)
    (1 <= remove[1] && remove[end] <= n) ||
        throw(ArgumentError("Vértices a serem removidos devem estar no intervalo 1:nvértices(g)."))

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

    lista_adj = g.lista_adj

    # Conta o número de arestas que serão removidas.
    # Para uma aresta que será removida, temos que assegurar
    # que tal aresta não é contada duas vezes quando ambas
    # de suas pontas forem removidas.
    n_arestas_removidas = 0
    for u in remove
       for v in lista_adj[u]
           if v >= u || vmap[v] != 0
               n_arestas_removidas += 1
           end
       end
    end

    g.m -= n_arestas_removidas

    # Mova as listas na lista de adjacência para suas novas posições.
    for u in 1:n
        if vmap[u] != 0
            lista_adj[vmap[u]] = lista_adj[u]
        end
    end
    resize!(lista_adj, n - length(remove))

    # remove os vértices das listas em lista_adj
    for lista in lista_adj
        Δ = 0
        for (i,v) in enumerate(lista)
            if vmap[v] == 0
                Δ += 1
            else
                lista[i - Δ ] = vmap[v]
            end
        end
        resize!(lista, length(lista) - Δ)
    end

    # Criaremos um vmap reverso, que mapeia vértices no grafo resultante
    # para aqueles do grafo original.
    vmap_reverso = Vector{Int64}(undef, nvértices(g))
    for (i,u) in enumerate(vmap)
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
narestas(g::ListaAdjacência) = g.m

"""
    é_aresta(g, u, v)

Devolve `true` se `(u,v)` for uma aresta de `g`
"""
é_aresta(g::ListaAdjacência, u::Integer, v::Integer) = u in g.lista_adj[v]
é_aresta(g::ListaAdjacência, (u,v)) = u in g.lista_adj[v]

"""
    nova_aresta!(g,u,v)

Adiciona uma nova aresta `(u,v)` ao grafo `g`. Devolve `true` se a adição foi
bem sucedida, ou `false` em caso contrário. As pontas das arestas já devem existir
no grafo.
"""
function nova_aresta!(g::ListaAdjacência, u, v)
    vs = vértices(g)
    (u in vs && v in vs) || return false    # alguma ponta não está no grafo
    lista = g.lista_adj[u]
    índice = searchsortedfirst(lista,v)
    (índice <= length(lista) && lista[índice] == v) && return false # aresta já no grafo
    insert!(lista, índice, v)

    g.m += 1
    u == v && return true # laço

    lista = g.lista_adj[v]
    índice = searchsortedfirst(lista,u)
    insert!(lista, índice, u)
    return true     # aresta adicionada com sucesso
end


nova_aresta!(g::ListaAdjacência, (u,v) ) = nova_aresta!(g, u, v)


"""
    remove_aresta!(g,u,v)

Remove uma nova `(u,v)` do grafo `g`. Devolve `true` se a remoção foi
bem sucedida, ou `false` em caso contrário. As pontas das arestas já
devem existir no grafo.
"""
function remove_aresta!(g::ListaAdjacência, u, v)
    vs = vértices(g)
    (u in vs && v in vs) || return false    # alguma ponta não está no grafo
    lista = g.lista_adj[u]
    índice = searchsortedfirst(lista,v)
    (índice <= length(lista) && lista[índice] == v) || return false # aresta fora do grafo
    deleteat!(lista, índice)

    g.m -= 1
    u == v && return true # laço

    lista = g.lista_adj[v]
    índice = searchsortedfirst(lista,u)
    deleteat!(lista, índice)
    return true     # aresta removida com sucesso
end

remove_aresta!(g::ListaAdjacência, (u,v) ) = remove_aresta!(g::ListaAdjacência, u, v)


mesma_aresta( (t,u), (v,w) ) = (t,u) == (v,w) || (u,t) == (v,w)


"""
    arestas(g)

Devolve a lista de arestas do grafo `g`
"""
function arestas(g::ListaAdjacência)
    lista_arestas = Vector{Tuple{Int64,Int64}}()
    n = nvértices(g)
    lista_adj = g.lista_adj
    for u in 1:n
        for v in lista_adj[u]
            if !((v,u) ∈ lista_arestas)
                push!(lista_arestas, (u,v))
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

g3 = ListaAdjacência([(1,2), (1,3), (2,4), (3,4), (4,5)])
remove_vértices!(g3, [4])

nvértices(g)   # 5 vértices
vértices(g)   # [1,2,3,4,5]
=#

end # module
