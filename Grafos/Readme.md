Para usar o conjunto de testes:

cd Grafos
julia

julia> ]
@v1.7) pkg> activate . <enter> (ativa o projeto atual)
(Grafos) pkg> test <enter>
(Grafos) pkg> <backspace>      (usar a tecla backspace (<--) para retornar ao julia)
julia>

Para usar o módulo Grafos, ative o projeto se ainda não o fez:
julia> ]
@v1.7) pkg> activate . <enter> (ativa o projeto atual)
(Grafos) pkg> <backspace>      (usar a tecla backspace (<--) para retornar ao julia)
julia>

Depois use o módulo:

julia> using Grafos

A partir daqui você pode usar quaisquer funções ou estruturas de dados exportadas pelo módulo:

julia> g = nulo()
ListaAdjacência(0, Vector{Int64}[])

julia> novo_vértice!(g)
1-element Vector{Vector{Int64}}:
 []

julia> novo_vértice!(g)
2-element Vector{Vector{Int64}}:
 []
 []

julia> nvértices(g)
2

julia> narestas(g)
0

julia> vértices(g)
2-element Vector{Int64}:
 1
 2

Veja o arquivo test/listaadjacência.jl para ver outros exemplos de uso.

2 - Testando as funções do trabalho

Já existe um arquivo de nome grafosEspeciais.jl contendo as assinaturas de todas as funções pedidas no trabalho. Todas elas retornam o grafo nulo, o que obviamente não é a solução correta, mas é importante para que os testes executem.

Sempre que for fazer um exercício comente a linha do exercício que for fazer, mas não a apague. Por exemplo, a primeira função está assim no arquivo

caminho(n::Int)::Grafo = nulo()

quando for fazer, comente-a:
#caminho(n::Int)::Grafo = nulo()
 e depois desenvolva seu código

function caminho(n::Int) 
   blá,blá,blá
end

Importante: código que não compila será zerado. 

Assim, se você não implementou alguma função, ou se sua implementação contém
erros, apague-a e mantenha a versão da função que estava no arquivo, ou seja,
aquela que você comentou em primeiro lugar. Com isto eu terei condições de
avaliar as demais funções que você implementou.

O seu código deve passar em todos os testes propostos. Sempre que alterar alguma
função, execute todos os testes.

Os passos a seguir só precisam ser feitos uma vez:
cd Grafos
julia

julia> ]
@v1.7) pkg> activate . <enter> (ativa o projeto atual)

E depois de qualquer módificação em grafosEspeciais.jl:
(Grafos) pkg> test <enter>

Se quiser voltar ao Julia e sair de Pkg, basta digitar:
(Grafos) pkg> <backspace>    (usar a tecla backspace (<--) para retornar ao julia)

Para entrar novamente em Pkg e voltar a testar
julia> ]
(Grafos) pkg> test <enter> 

Note que a ativação do projeto só precisa ser feita uma vez por sessão.


Referências:
https://erik-engheim.medium.com/julia-v1-5-testing-best-practices-3ca8780e6336
https://www.matecdev.com/posts/julia-testing.html
https://towardsdatascience.com/how-to-test-your-software-with-julia-4050379a9f3
