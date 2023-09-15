//
//  IngredientSearchPage.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 13/09/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente*/

import Foundation


//MARK: Propiedades del objeto ingrediente
struct IngredientSearchPage: Codable, Hashable {
    let idUUID = UUID() /***Identificador unico pra evitar problemas con el datasource de la vista de "RecipeHome"*/
    let id: Int
    let aisle: String
    let imagePNG: String?
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case idUUID
        case id
        case aisle
        case imagePNG = "image"
        case name
    }
}
