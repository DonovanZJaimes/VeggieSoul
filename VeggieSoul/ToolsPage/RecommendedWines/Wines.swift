//
//  Wines.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 26/09/23.
//
//MARK: INFO:
/*Creacion del modelo de la info que ocuparan las celdas de WineDetail y RecommendedWines */

import Foundation

struct Wines: Codable, Hashable {
    let recommendedWines: [RecommendedWine]
    let totalFound: Int
}

// MARK: - RecommendedWine
struct RecommendedWine: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico pra evitar problemas con el datasource de " RecommendedWines"*/
    let id: Int
    let title: String
    let description: String?
    let imageURL: String
    let link: String
    let price: String
    let ratingCount: Int
    let averageRating: Double

    enum CodingKeys: String, CodingKey {
        case id
        case idUUID
        case title
        case description
        case imageURL = "imageUrl"
        case link
        case price
        case ratingCount
        case averageRating
    }
}
