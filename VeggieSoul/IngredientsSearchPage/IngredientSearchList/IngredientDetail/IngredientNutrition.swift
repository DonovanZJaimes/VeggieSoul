//
//  IngredientNutrition.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//
//MARK: INFO:
/*Creacion del objeto de la informacion nutriental de  un ingrediente*/

import Foundation


//MARK: Propiedades nutrimentales del ingrediente
struct IngredientNutrition: Codable, Hashable {
    let nutrients: [IngredientNutrients]
    let caloricBreakdown: IngredientCaloricBreakdown
    let weightPerServing: IngredientWeightPerServing
    
    enum CodingKeys: String, CodingKey {
        case nutrients
        case caloricBreakdown
        case weightPerServing
    }
}
