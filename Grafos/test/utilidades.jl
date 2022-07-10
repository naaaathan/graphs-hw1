
function gera_mapas_vértices(vs)
    mapa = Dict( letra => num  for (num, letra) in enumerate(vs) )
    mapa_rev = Dict( num => letra for (letra, num) in mapa )
    return (mapa, mapa_rev)
end

mapeia_vértices(mapa, vs) = map(v -> mapa[v], vs)

mapeia_arestas(mapa, ars) =  [ (mapa[u], mapa[v]) for (u,v) in ars ]


