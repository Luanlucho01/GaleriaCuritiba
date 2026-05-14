//
//  ObraDeArte.swift
//  GaleriaCuritiba
//
//  Camada Model: representa uma obra na galeria (dados puros, sem UI).
//

import Foundation

/// Dados de uma obra de arte vinculada a artistas com ligação a Curitiba.
/// A imagem referenciada por `imagemNome` deve existir no Assets Catalog.
struct ObraDeArte: Equatable {
    let titulo: String
    let artista: String
    let ano: Int
    let estilo: String
    /// Nome do conjunto de imagens no Asset Catalog (ex.: "obra_andersen").
    let imagemNome: String
    let descricao: String
}
