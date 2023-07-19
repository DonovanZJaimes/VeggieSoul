//
//  IngredientAutocomplete.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 03/07/23.
//
//MARK: INFO:
/*Creacion del objeto de un ingrediente autoacompletado*/


import Foundation

typealias IngredientsAutocomplete = [IngredientAutocomplete]

//MARK: Propiedades del ingrediente
struct IngredientAutocomplete: Hashable, Codable {
    let name: String
    let image: String
    let id: Int
    let aisle: String
}


