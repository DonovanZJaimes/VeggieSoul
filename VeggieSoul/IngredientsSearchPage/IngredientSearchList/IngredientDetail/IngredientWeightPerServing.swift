//
//  IngredientWeightPerServing.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//
//MARK: INFO:
/*Creacion del objeto de la informacion de peso de un ingrediente*/

import Foundation


//MARK: Propiedades de peso del ingrediente
struct IngredientWeightPerServing: Codable, Hashable {
    let amount: Int
    let unit: String
    
    enum CodingKeys: String, CodingKey {
        case amount
        case unit
    }
}
