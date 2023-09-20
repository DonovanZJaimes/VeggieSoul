//
//  IngredientID.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente por medio de su ID*/

import Foundation


//MARK: Propiedades del objeto ingrediente
struct IngredientID: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico para evitar problemas con el datasource */
    let id: Int
    let image: String
    let name: String
    let originalName: String
    let aisle: String
    let consistency: String
    let nutrition: IngredientNutrition
    
    enum CodingKeys: String, CodingKey {
        case idUUID
        case id
        case image
        case name
        case originalName
        case aisle
        case consistency
        case nutrition
    }
}
