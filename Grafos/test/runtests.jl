using Grafos

using Test

const testdir = dirname(@__FILE__)

# Descomente o trecho abaixo se você não quiser ver o StackTrace

#=
Test.eval(quote
              function record(ts::DefaultTestSet, t::Union{Fail, Error})
                  push!(ts.results, t)
              end
          end)
=#

testes = [
    # "utilidades",
    # "listaadjacência",
    # "matrizadjacência",
    # descomente a linha abaixo e apague as linhas anteriores
    # quando for fazer o trabalho.
    "grafosespeciais"
]

@testset "Grafos" begin
    for t in testes
        ct = joinpath(testdir, "$(t).jl")
        include(ct)
    end
end
