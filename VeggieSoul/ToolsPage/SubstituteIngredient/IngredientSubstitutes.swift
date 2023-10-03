//
//  IngredientSubstitutes.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 02/10/23.
//MARK: INFO:
/*Creacion del objeto para encontrar diferentes sustitutos de un ingrediente*/

import Foundation

struct IngredientSubstitutes: Codable {
    let ingredient: String?
    let substitutes: [String]?
    let message: String
}
