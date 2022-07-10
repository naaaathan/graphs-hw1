using Grafos

@testset "Grafos Especiais" begin
    @testset "caminho" begin
        @test seqGraus(caminho(1)) == [0]
        @test seqGraus(caminho(5)) == [1, 1, 2, 2, 2]
        @test seqGraus(caminho(8)) == [1, 1, 2, 2, 2, 2, 2, 2]
        @test narestas(caminho(16)) == 15
        @test narestas(caminho(32)) == 31
    end

    @testset "grade" begin
        @test seqGraus(grade(1, 1)) == [0]
        @test seqGraus(grade(3, 3)) == [2, 2, 2, 2, 3, 3, 3, 3, 4]
        @test nvértices(grade(5, 8)) == 40
        @test narestas(grade(7, 11)) == 136
        @test narestas(grade(9, 8)) == 127
    end

    @testset "dama" begin
        @test seqGraus(dama(3)) == [6, 6, 6, 6, 6, 6, 6, 6, 8]
        @test seqGraus(dama(4)) == [9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 11, 11, 11, 11]
        @test nvértices(dama(5))  == 25
        @test nvértices(dama(10)) == 100
        @test narestas(dama(7)) == 476
        @test narestas(dama(9)) == 1056
    end

    @testset "cavalo" begin
        @test seqGraus(cavalo(3)) == [0, 2, 2, 2, 2, 2, 2, 2, 2]
        @test seqGraus(cavalo(4)) == [2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4]
        @test nvértices(cavalo(5))  == 25
        @test nvértices(cavalo(10)) == 100
        @test narestas(cavalo(7)) == 120
        @test narestas(cavalo(9)) == 224
    end

    @testset "bispo" begin
        @test seqGraus(bispo(3)) == [2, 2, 2, 2, 2, 2, 2, 2, 4]
        @test seqGraus(bispo(4)) == [3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5, 5]
        @test nvértices(bispo(5))  == 25
        @test nvértices(bispo(10)) == 100
        @test narestas(bispo(7)) == 182
        @test narestas(bispo(9)) == 408
    end

    @testset "torre" begin
        @test seqGraus(torre(3)) == [4, 4, 4, 4, 4, 4, 4, 4, 4]
        @test seqGraus(torre(4)) == [6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6]
        @test nvértices(torre(5))  == 25
        @test nvértices(torre(10)) == 100
        @test narestas(torre(7)) == 294
        @test narestas(torre(9)) == 648
    end

    @testset "rei" begin
        @test seqGraus(rei(2)) == [3, 3, 3, 3]
        @test seqGraus(rei(3)) == [3, 3, 3, 3, 5, 5, 5, 5, 8]
        @test seqGraus(rei(4)) == [3, 3, 3, 3, 5, 5, 5, 5, 5, 5, 5, 5, 8, 8, 8, 8]
        @test nvértices(rei(5)) == 25
        @test nvértices(rei(10)) == 100
        @test narestas(rei(7)) == 156
        @test narestas(rei(9)) == 272
    end

    @testset "cubo" begin
        @test seqGraus(cubo(2)) == [2, 2, 2, 2]
        @test seqGraus(cubo(3)) == [3, 3, 3, 3, 3, 3, 3, 3]
        @test seqGraus(cubo(4)) == [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
        @test nvértices(cubo(5)) == 32
        @test nvértices(cubo(6)) == 64
        @test narestas(cubo(7)) == 448
    end

    @testset "petersen" begin
        @test seqGraus(petersen()) == [3, 3, 3, 3, 3, 3, 3, 3, 3, 3]
        @test narestas(petersen()) == 15
    end

    @testset "ciclo" begin
        @test seqGraus(ciclo(3)) == [2, 2, 2]
        @test seqGraus(ciclo(4)) == [2, 2, 2, 2]
        @test seqGraus(ciclo(5)) == [2, 2, 2, 2, 2]
        @test narestas(ciclo(10)) == 10
        @test narestas(ciclo(11)) == 11
    end

    @testset "completo" begin
        @test seqGraus(completo(3)) == [2, 2, 2]
        @test seqGraus(completo(4)) == [3, 3, 3, 3]
        @test seqGraus(completo(5)) == [4, 4, 4, 4, 4]
        @test seqGraus(completo(8)) == [7, 7, 7, 7, 7, 7, 7, 7]
        @test narestas(completo(10)) == 45
    end

    @testset "amigo" begin
        @test seqGraus(amigo(2)) == [2, 2, 2, 2, 4]
        @test seqGraus(amigo(3)) == [2, 2, 2, 2, 2, 2, 6]
        @test seqGraus(amigo(4)) == [2, 2, 2, 2, 2, 2, 2, 2, 8]
        @test seqGraus(amigo(8)) == [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 16]
        @test narestas(amigo(8)) == 24
    end

    @testset "roda" begin
        @test seqGraus(roda(4)) == [3, 3, 3, 3]
        @test seqGraus(roda(5)) == [3, 3, 3, 3, 4]
        @test seqGraus(roda(6)) == [3, 3, 3, 3, 3, 5]
        @test seqGraus(roda(7)) == [3, 3, 3, 3, 3, 3, 6]
        @test seqGraus(roda(9)) == [3, 3, 3, 3, 3, 3, 3, 3, 8]
        @test narestas(roda(9)) == 16
    end

    @testset "estrela" begin
        @test seqGraus(estrela(3)) == [1, 1, 1, 3]
        @test seqGraus(estrela(4)) == [1, 1, 1, 1, 4]
        @test nvértices(estrela(5)) == 6
        @test nvértices(estrela(10)) == 11
        @test narestas(estrela(7)) == 7
        @test narestas(estrela(9)) == 9
    end
end
