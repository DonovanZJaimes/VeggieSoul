//
//  IngredientRecipeList.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//

//MARK: INFO:
/*Creacion del objeto de los ingredientes que serviran para realizar la solicitud de red*/

import Foundation

//MARK: Propiedades del ingrediente
struct IngredientRecipeList: Codable, Hashable {
    //let id: Int
    let imagePNG: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        //case id
        case imagePNG = "image"
        case name
    }
}
