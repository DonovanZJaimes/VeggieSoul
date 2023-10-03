//
//  AutocompleteWordIngredientsToToolsPage.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/09/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente autoacompletado*/

import Foundation

typealias AutocompleteWordIngredientsToToolsPage = [AutocompleteWordIngredientToToolsPage]

//MARK: Propiedades del ingrediente
struct AutocompleteWordIngredientToToolsPage: Hashable, Codable {
    let id: Int
    let name: String
    let image: String
    let aisle: String?
    let possibleUnits: [String]
}
