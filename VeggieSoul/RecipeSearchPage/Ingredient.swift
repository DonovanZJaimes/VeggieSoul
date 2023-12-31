//
//  Ingredient.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/06/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta aleatoria*/

import Foundation


//MARK: Propiedades del objeto ingrediente
struct Ingredient: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico pra evitar problemas con el datasource de la vista de "RecipeHome"*/
    let id: Int
    let imagePNG: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case idUUID
        case id
        case imagePNG = "image"
        case name
    }
}
