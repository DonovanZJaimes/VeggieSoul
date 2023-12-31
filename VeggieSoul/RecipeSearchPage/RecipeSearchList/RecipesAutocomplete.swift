//
//  RecipesAutocomplete.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 03/07/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta auto acompletada*/


import Foundation

typealias RecipesAutocomplete = [RecipeAutocomplete]

//MARK: Propiedades de la receta
struct RecipeAutocomplete: Hashable, Codable {
    let id: Int
    let name: String
    let imageType: String
    
    
    enum CodingKeys: String, CodingKey  {
        case id
        case name = "title"
        case imageType
    }
}


