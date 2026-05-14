//
//  GaleriaCatalogo.swift
//  GaleriaCuritiba
//
//  Camada Model: fonte estática de obras (simula um repositório simples).
//

import Foundation

enum GaleriaCatalogo {
    /// Lista fixa de obras de exemplo; em um app real poderia vir de JSON/API.
    static let todasAsObras: [ObraDeArte] = [
        ObraDeArte(
            titulo: "Paisagem do Paraná",
            artista: "Alfredo Andersen",
            ano: 1910,
            estilo: "Impressionismo",
            imagemNome: "obra_andersen",
            descricao: "Andersen (1860–1940) é referência do impressionismo no Paraná; suas paisagens celebram a luz e a natureza da região."
        ),
        ObraDeArte(
            titulo: "Cores da cidade",
            artista: "Guido Viaro",
            ano: 1955,
            estilo: "Modernismo",
            imagemNome: "obra_viaro",
            descricao: "Viaro (1887–1969) trouxe influências europeias e registrou Curitiba em obras que misturam realismo e sensibilidade moderna."
        ),
        ObraDeArte(
            titulo: "Curitiba em traço",
            artista: "Poty Lazzarotto",
            ano: 1980,
            estilo: "Gravura / ilustração",
            imagemNome: "obra_lazzarotto",
            descricao: "Poty (1924–1998) marcou a cidade com xilogravuras e ilustrações que viraram ícones do imaginário curitibano."
        ),
        ObraDeArte(
            titulo: "Sala de arte paranaense",
            artista: "Coleção MAC-PR",
            ano: 2000,
            estilo: "Vários",
            imagemNome: "obra_museum",
            descricao: "O Museu de Arte Contemporânea do Paraná, em Curitiba, reúne produções que dialogam com a arte brasileira e local."
        ),
        ObraDeArte(
            titulo: "Intervenção urbana",
            artista: "Coletivo curitibano",
            ano: 2018,
            estilo: "Arte urbana",
            imagemNome: "obra_contemporanea",
            descricao: "A cena contemporânea da capital paranaense explora muralismo e arte pública em espaços coletivos."
        ),
        ObraDeArte(
            titulo: "Estudo em grafite",
            artista: "Artista local",
            ano: 2022,
            estilo: "Desenho contemporâneo",
            imagemNome: "obra_grafica",
            descricao: "Exemplo de pesquisa gráfica atual, comum em mostras e feiras de arte independentes em Curitiba."
        ),
    ]

    /// Filtra por título ou nome do artista (case insensitive, diacríticos ignorados).
    static func obras(matching query: String) -> [ObraDeArte] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return todasAsObras }
        return todasAsObras.filter {
            $0.titulo.localizedCaseInsensitiveContains(trimmed)
                || $0.artista.localizedCaseInsensitiveContains(trimmed)
        }
    }
}
