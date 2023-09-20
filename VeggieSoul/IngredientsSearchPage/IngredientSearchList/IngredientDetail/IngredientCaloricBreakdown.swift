//
//  IngredientCaloricBreakdown.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//
//MARK: INFO:
/*Creacion del objeto de la informacion CaloricBreakdown de  un ingrediente*/

import Foundation


//MARK: Propiedades nutrimentales del ingrediente
struct IngredientCaloricBreakdown: Codable, Hashable {
    let percentProtein: Double
    let percentFat: Double
    let percentCarbs: Double
    
    enum CodingKeys: String, CodingKey {
        case percentProtein
        case percentFat
        case percentCarbs
        
    }
}
