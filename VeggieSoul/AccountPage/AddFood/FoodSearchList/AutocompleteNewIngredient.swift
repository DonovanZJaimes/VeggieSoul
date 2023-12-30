//
//  AutocompleteNewIngredient.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente autoacompletado*/

import Foundation

typealias AutocompleteNewIngredients = [AutocompleteNewIngredient]

//MARK: Propiedades del ingrediente autocompletado
struct AutocompleteNewIngredient: Hashable, Codable {
    let name: String
    let image: String?
    let id: Int
    let possibleUnits: [String]
    
}
