//
//  Recipes.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/06/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta aleatoria*/

import Foundation

struct Recipes: Codable, Hashable {
    let recipes: [Recipe]
    //let totalResults: Int
}
//MARK: Propiedades de la receta
struct Recipe: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico pra evitar problemas con el datasource de la vista de "RecipeHome"*/
    let name: String
    let likes: Int
    let id: Int
    let minutes: Int
    let imageURL: String?
    let imageType: String?
    let ingredients: [Ingredient]
    
    
    enum CodingKeys: String, CodingKey {
        case idUUID
        case name = "title"
        case likes = "aggregateLikes"
        case id
        case minutes = "readyInMinutes"
        case imageURL = "image"
        case imageType
        case ingredients = "extendedIngredients"
        
    }
}

