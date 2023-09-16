//
//  AutocompleteWordIngredient.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/09/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente autoacompletado*/

import Foundation

typealias AutocompleteWordIngredients = [AutocompleteWordIngredient]

//MARK: Propiedades del ingrediente
struct AutocompleteWordIngredient: Hashable, Codable {
    let name: String
    let image: String
    let id: Int
    let aisle: String
}
