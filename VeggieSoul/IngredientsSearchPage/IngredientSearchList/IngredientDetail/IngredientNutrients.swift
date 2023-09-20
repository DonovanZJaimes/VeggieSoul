//
//  IngredientNutrients.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//
//MARK: INFO:
/*Creacion del objeto de la informacion de los nutrientes de  un ingrediente*/

import Foundation


//MARK: Propiedades nutrimentales del ingrediente
struct IngredientNutrients: Codable, Hashable {
    let name: String
    let amount: Double
    let unit: String
    let percentOfDailyNeeds: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case unit
        case percentOfDailyNeeds
    }
}
