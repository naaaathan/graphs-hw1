export caminho,
    grade,
    dama,
    bispo,
    cavalo,
    torre,
    rei,
    cubo,
    petersen,
    ciclo,
    completo,
    amigo,
    roda,
    estrela

""""
    caminho(n)

Devolve um grafo caminho com `n` vértices.
"""
#caminho(n::Int)::Grafo = nulo()
function geraGrafoCaminho(grf::Grafo,n::Int)

    #Pegar um vertices(g) aleatório e criar uma aresta entre eles de forma
    # a respeitar a definição de caminho, ou seja, n repetir arestas e vértices
    for x in 1:n
        if mod(x, 2) == 0
            nova_aresta!(grf, x, x - 1)
        end
    end
    
    for x in 1:n
        if mod(x, 2) == 0
            nova_aresta!(grf, x, x - 1)
        elseif x != 1
            nova_aresta!(grf, x, x - 1)
        end
    end

end # function


function caminho(n::Int)
    grf = nulo()

    #Gerar os n vértices do caminho
    for u in 1:n
        novo_vértice!(grf)
    end # for

    geraGrafoCaminho(grf,n)

    return grf

end


""""
   grade(p, q)

Devolve uma grade `p`-por-`q`.
Veja o exercício E 1.6 do livro do Paulo Feofiloff.
"""
#grade(p::Int, q::Int)::Grafo = nulo()

function criaColuna(g::Grafo, p::Int, q::Int, linhas::Int)

    for x in p:q-1
        nova_aresta!(g, x, x + 1)
    end

    for y in p:q
        nova_aresta!(g, y, y + linhas)
    end


end # function

function geraGrade(grf::Grafo, p::Int, q::Int)

    #Criar p linhas e q colunas, pxq vértices
    qtd_vertices = p * q

    for n in 1:qtd_vertices
        novo_vértice!(grf)
    end

    visited = false
    coluna = 1

    for x in 1:qtd_vertices
        if mod(x, p) == 0
            visited = false
            continue
        elseif !visited
            criaColuna(grf, x, p * coluna, p)
            visited = true
            coluna += 1
        end
    end

    return grf
end # function

function grade(p::Int, q::Int)

    grf = nulo()

    grf = geraGrade(grf, p, q)
    # Grade deve conter p colunas e q linhas, tal que linhas e colunas tem arestas com as adjacentes
    # 1 4 7 10
    # 2 5 8 11
    # 3 6 9 12

end


"""
   dama(t)

Devolve o grafo da dama |t|-por-|t|.
Veja o exercício E 1.8 do livro do Paulo Feofiloff.
"""
#dama(t::Int)::Grafo = nulo()

function criar_arestas_horizontalmente_adjacentes(grf::Grafo, t::Int)
    qtd_vertices = t * t

    for x in 1:qtd_vertices
        counter = t
        while é_vértice(grf, x) && é_vértice(grf, x + counter)
            nova_aresta!(grf, x, x + counter)
            nova_aresta!(grf, x + counter, x)
            counter = counter + t
        end
    end
end

function criar_arestas_verticalmente_adjacentes(grf::Grafo, t::Int)

    qtd_vertices = t * t

    colunas = []
    coluna_x = []

    for x in 1:qtd_vertices
        if mod(x, t) == 0
            push!(coluna_x, x)
            push!(colunas, coluna_x)
            coluna_x = []
        else
            push!(coluna_x, x)
        end
    end

    for y in 1:length(colunas)
        y_coluna = colunas[y]
        for z in 1:length(y_coluna)
            counter = 1
            while é_vértice(grf, z) &&
                      z + counter <= length(y_coluna) &&
                      é_vértice(grf, z + counter)
                nova_aresta!(grf, y_coluna[z], y_coluna[z+counter])
                nova_aresta!(grf, y_coluna[z+counter], y_coluna[z])
                counter += 1
            end
        end
    end
end


function criar_arestas_diagonalmente_adjacentes(grf::Grafo, t::Int)

    qtd_vertices = t * t

    colunas = []
    colunasTemp = []

    for n in 1:qtd_vertices
        if mod(n, t) == 0
            push!(colunasTemp, n)
            push!(colunas, colunasTemp)
            colunasTemp = []
        else
            push!(colunasTemp, n)
        end
    end

    for p in 1:length(colunas)
        coluna = colunas[p]
        for q in 1:length(coluna)
            val_col = p
            val_lin = q

            while val_lin > 1 &&
                      val_col < t &&
                      val_lin <= t &&
                      é_vértice(grf, colunas[val_col+1][val_lin-1])
                nova_aresta!(grf, colunas[p][q], colunas[val_col+1][val_lin-1])
                val_col = val_col + 1
                val_lin = val_lin - 1

                if val_col >= t
                    break
                end
            end

            val_col = p
            val_lin = q

            while val_col < t &&
                      val_lin < t &&
                      é_vértice(grf, colunas[val_col+1][val_lin+1])
                nova_aresta!(grf, colunas[p][q], colunas[val_col+1][val_lin+1])
                val_col = val_col + 1
                val_lin = val_lin + 1

                if val_col >= t || val_lin >= t
                    break
                end

            end
            # 1 4 7
            # 2 5 8
            # 3 6 9

            #[11] [21] [31] [41]
            #[12] [22] [32] [42]
            #[13] [23] [33] [43]
            #[14] [24] [34] [44]
            #(coluna+1 && linha-1 )
            #(coluna+1 && linha+1 )
            # end
        end
    end

end

function dama(t::Int)
    grf = nulo()
    n_vertices = t * t

    #Criar vértices do tabuleiro
    for x in 1:n_vertices
        novo_vértice!(grf)
    end


    #Os movimentos possiveis da dama podem ser dividos em
    #horizontal vertical e diagonal, split em functions para
    #reutilizar em outros movimentos

    criar_arestas_horizontalmente_adjacentes(grf, t)
    criar_arestas_verticalmente_adjacentes(grf, t)
    criar_arestas_diagonalmente_adjacentes(grf, t)

    return grf

end # function

"""
  cavalo(t)

Devolve o grafo do cavalo |t| por |t|. Os vértices, ou seja, as casas do
tabuleiro, devem ser numerados de 1 a t^2, de baixo para cima e da
esquerda para a direita. Veja o exercício E 1.9 do livro do Paulo Feofiloff.
Dica: para se inspirar, leia o documento em

    https://bradfieldcs.com/algos/graphs/knights-tour
"""
#cavalo(t::Int)::Grafo = nulo()
function geraGrafoMovimentoCavalo(grf::Grafo,qtd_vertices::Int,t::Int)

    colunas = []
    coluna_x = []

    for x in 1:qtd_vertices
        if mod(x, t) == 0
            push!(coluna_x, x)
            push!(colunas, coluna_x)
            coluna_x = []
        else
            push!(coluna_x, x)
        end
    end

    #Cavalo tem posicionamento de 2 colunas e 1 linha ou 2 linhas e 1 coluna
    #da posição atual..logo calculando tais valores criamos as arestas possiveis
    for i in 1:t
        for j in 1:t
            if i+2 <= t && j+1 <= t
                nova_aresta!(grf,colunas[i][j],colunas[i+2][j+1])
            end
            if i+2 <= t && j-1 > 0
                nova_aresta!(grf,colunas[i][j],colunas[i+2][j-1])
            end
            if i+1 <= t && j+2 <=t
                nova_aresta!(grf,colunas[i][j],colunas[i+1][j+2])
            end
            if i-2 > 0 && j - 1 > 0
                nova_aresta!(grf,colunas[i][j],colunas[i-2][j-1])
            end
            if i -2 > 0 && j+1 <= t
                nova_aresta!(grf,colunas[i][j],colunas[i-2][j+1])
            end
            if i-1 > 0 && j-2 > 0
                nova_aresta!(grf,colunas[i][j],colunas[i-1][j-2])
            end
            if i-1 > 0 && j+2 <= t
                nova_aresta!(grf,colunas[i][j],colunas[i-1][j+2])
            end
        end
    end
end # function

function cavalo(t::Int)

    grf = nulo()
    qtd_vertices = t * t

    novos_vértices!(grf,qtd_vertices)

    geraGrafoMovimentoCavalo(grf,qtd_vertices,t)

    return grf

end # function

"""
   bispo(t)

Devolve o grafo do bispo |t|-por-|t|.
Veja o exercício E 1.10 do livro do Paulo Feofiloff.
"""
#bispo(t::Int)::Grafo = nulo()

function bispo(t::Int)
    grf = nulo()
    n_vertices = t * t

    #Criar vértices do tabuleiro
    for x in 1:n_vertices
        novo_vértice!(grf)
    end

    #Bispo se movimenta apenas pelas diagonais..reaproveitar função da dama
    criar_arestas_diagonalmente_adjacentes(grf, t)

    return grf
end # function

"""
   torre(t)

Devolve o grafo da torre |t|-por-|t|.
Veja o exercício E 1.11 do livro do Paulo Feofiloff.
"""
# torre(t::Int)::Grafo = nulo()
function torre(t::Int)
    grf = nulo()

    qtd_vertices = t * t

    #Criar vértices do tabuleiro
    for x in 1:qtd_vertices
        novo_vértice!(grf)
    end

    #Torres se movimentam pela horizontal e vertical..reaproveitar funções já escritas da dama
    criar_arestas_verticalmente_adjacentes(grf, t)
    criar_arestas_horizontalmente_adjacentes(grf, t)

    return grf
end # function

"""
   rei(t)

Devolve o grafo do rei |t|-por-|t|.
Veja o exercício E 1.12 do livro do Paulo Feofiloff.
"""
#rei(t::Int)::Grafo = nulo()
function geraGrafoMovimentoRei(grf::Grafo,qtd_vertices::Int,t::Int)

    colunas = []
    colunasTemp = []

    for n in 1:qtd_vertices
        if mod(n, t) == 0
            push!(colunasTemp, n)
            push!(colunas, colunasTemp)
            colunasTemp = []
        else
            push!(colunasTemp, n)
        end
    end

        # 11 21 31
        # 12 22 32
        # 13 23 33

    for i in 1:length(colunas)
        for j in 1:length(colunas[i])
            if j < t && é_vértice(grf, colunas[i][j+1])
                nova_aresta!(grf, colunas[i][j], colunas[i][j+1])
            end
            if j > 1 && é_vértice(grf, colunas[i][j-1])
                nova_aresta!(grf, colunas[i][j], colunas[i][j-1])
            end
            if i < t && é_vértice(grf, colunas[i+1][j])
                nova_aresta!(grf, colunas[i][j], colunas[i+1][j])
            end
            if i > 1 && é_vértice(grf, colunas[i-1][j])
                nova_aresta!(grf, colunas[i][j], colunas[i-1][j])
            end
            if i > 1 && j > 1 && é_vértice(grf, colunas[i-1][j-1])
                nova_aresta!(grf, colunas[i][j], colunas[i-1][j-1])
            end
            if i < t && j < t && é_vértice(grf, colunas[i+1][j+1])
                nova_aresta!(grf, colunas[i][j], colunas[i+1][j+1])
            end
            if i < t && j > 1 && é_vértice(grf, colunas[i+1][j-1])
                nova_aresta!(grf, colunas[i][j], colunas[i+1][j-1])
            end
            if i > 1 && j < t && é_vértice(grf, colunas[i-1][j+1])
                nova_aresta!(grf, colunas[i][j], colunas[i-1][j+1])
            end
        end
    end
end # function

function rei(t::Int)

    grf = nulo()

    qtd_vertices = t * t

    #Criar vértices do tabuleiro
    for x in 1:qtd_vertices
        novo_vértice!(grf)
    end

    geraGrafoMovimentoRei(grf,qtd_vertices,t)

    return grf
end # function

"""
   cubo(k)

Devolve o grafo do cubo de dimensão |k|.
Veja o exercício E 1.14 do livro do Paulo Feofiloff.
"""

#cubo(k)::Grafo = nulo()
function cubo(k::Int)

    grf = nulo()

    #Número de vértices do cubo segue a exponencial de 2 2^k
    nr_vertices = (2^k)
    novos_vértices!(grf,nr_vertices)

    # 1 3
    # 2 4

    #Usar a função string para saber quantos valores são diferentes no valor binario
    #se tiver exatamente 1 um a mais ou 1 um a menos logo são adjacente segundo a definição
    #do livro.

    for i in 0:nr_vertices+1
        string_binario_i = string(i,base=2,pad=k+1)
        for j in 0:nr_vertices+1
            diferenca = 0
            string_binario_j = string(j,base=2,pad=k+1)
            for p in 1:length(string_binario_i)
                if string_binario_i[p] != string_binario_j[p]
                    diferenca+=1
                end
            end
            if diferenca == 1
                 nova_aresta!(grf,i+1,j+1)
            end
        end
    end
    return grf
end


"""
   petersen()

Devolve o grafo de Petersen.
Veja o exercício E 1.15 do livro do Paulo Feofiloff.
"""
#petersen()::Grafo = nulo()

function petersen()

    grf = nulo()

    total_vertices = 10

    novos_vértices!(grf,total_vertices)

    vertices_exteriores = 5
    vertices_interiores = 5

    for i in 1:vertices_exteriores
        if i == 5
            nova_aresta!(grf,i,1)
        else
            nova_aresta!(grf,i,i+1)
        end
    end

    for i in 1:vertices_interiores
        nova_aresta!(grf,i,vertices_interiores+i)
    end

    nova_aresta!(grf,6,8)
    nova_aresta!(grf,6,9)
    nova_aresta!(grf,7,9)
    nova_aresta!(grf,7,10)
    nova_aresta!(grf,8,10)

    return grf

end # function

"""
   ciclo(n)

Devolve um grafo ciclo com |n| vértices.
"""
#ciclo(n::Int)::Grafo = nulo()

function ciclo(f::Int)
    g = caminho(f)
    nova_aresta!(g, 1, f)
    return g
end

"""
  completo(n)

Devolve um grafo completo com |n| vértices (K_n).
"""
# completo(n::Int)::Grafo = nulo()

function completo(n::Int)

    grf = nulo()

    #Criar vértices do tabuleiro
    for x in 1:n
        novo_vértice!(grf)
    end

    for i in 1:n
        for j in 1:n
            if i != j
                nova_aresta!(grf, i, j)
            end
        end
    end

    return grf

end # function

"""
   amigo(n)

Devolve um grafo amigo com |2n+1| vértices e |3n| arestas.
Ver
   https://en.wikipedia.org/wiki/Friendship_graph
"""
# amigo(n::Int)::Grafo = nulo()

function amigo(n::Int)

    grf = nulo()

    nr_vertices = ((2*n)+1)
    novos_vértices!(grf,nr_vertices)

    vertice_amigo = 1

    for i in 2:nr_vertices
        if mod(i-vertice_amigo,2) == 0
            nova_aresta!(grf,i,i-1)
            nova_aresta!(grf,vertice_amigo,i)
            nova_aresta!(grf,vertice_amigo,i-1)
        end
    end

    return grf

end # function


"""
   roda(n)

Devolve um grafo roda com |n| vértices.
Ver
  https://en.wikipedia.org/wiki/Wheel_graph
"""
# roda(n::Int)::Grafo = nulo()
function roda(n::Int)

    grf = nulo()
    nr_vertices = n

    vertice_central = 1

    novos_vértices!(grf,nr_vertices)

    for i in 2:nr_vertices
        nova_aresta!(grf,i,vertice_central)
        if i == nr_vertices
            nova_aresta!(grf,i,vertice_central+1)
        else
            nova_aresta!(grf,i,i+1)
        end
    end
    return grf
end # function

"""
   estrela(n)

Devolve um grafo estrela com |n+1| vértices.
Ver
   https://pt.wikipedia.org/wiki/Estrela_(teoria_dos_grafos)
"""
#estrela(n::Int)::Grafo = nulo()
function estrela(n::Int)

    grf = nulo()

    nr_vertices = n+1
    vertice_central = 1

    novos_vértices!(grf,nr_vertices)
    for i in 2:nr_vertices
        nova_aresta!(grf,i,vertice_central)
    end
    return grf
end
