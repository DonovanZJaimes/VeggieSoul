//
//  RecipeByCategory.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta por el tipo de categoria*/

import Foundation

struct RecipesByCategory: Codable, Hashable {
    let recipes: [RecipeByCategory]
}

//MARK: Propiedades de la receta por categoria
struct RecipeByCategory: Codable, Hashable {
    let likes: Int
    let ingredients: [IngredientsIDByCategory]
    let id: Int
    let name: String
    let image: String?
    
    enum CodingKeys: String, CodingKey{
        case likes = "aggregateLikes"
        case ingredients = "extendedIngredients"
        case id
        case name = "title"
        case image
    }

}

//MARK: Propiedades de los ingredientes de la receta anterior
struct IngredientsIDByCategory: Codable, Hashable {
    let id: Int
    
    enum CodingKeys: String, CodingKey{
        case id
    }
}
