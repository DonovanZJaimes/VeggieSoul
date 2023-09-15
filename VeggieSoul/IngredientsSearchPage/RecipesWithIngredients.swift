//
//  RecipesWithIngredients.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 13/09/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta aleatoria junto con sus ingredientes*/

import Foundation

struct RecipesWithIngredients: Codable, Hashable {
    let recipes: [RecipeWithIngredients]
    //let totalResults: Int
}

//MARK: Propiedades de la receta
struct RecipeWithIngredients: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico pra evitar problemas con el datasource de la vista de "RecipeHome"*/
    let name: String
    let ingredients: [IngredientSearchPage]
    
    
    enum CodingKeys: String, CodingKey {
        case idUUID
        case name = "title"
        case ingredients = "extendedIngredients"
        
    }
}
