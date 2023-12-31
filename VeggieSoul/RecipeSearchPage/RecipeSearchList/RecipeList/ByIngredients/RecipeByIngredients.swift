//
//  RecipeByIngredients.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta por el tipo de ingredientes*/


import Foundation

typealias RecipesByIngredient = [RecipeByIngredient]


//MARK: Propiedades de la receta
struct RecipeByIngredient: Codable, Hashable {
    let id: Int
    let name: String
    let image: String
    let missedIngredientCount: Int
    let usedIngredientCount: Int
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "title"
        case image
        case missedIngredientCount
        case usedIngredientCount
        case likes
    }
    //MARK: Total de ingredientes que tenga la receta
    var ingredientsCount: Int {
        return missedIngredientCount + usedIngredientCount /***Se regresa el total de ingredientes de la receta*/
    }
}
