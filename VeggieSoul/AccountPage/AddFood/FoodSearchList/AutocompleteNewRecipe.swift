//
//  AutocompleteNewRecipe.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Creacion del objeto de una receta autoacompletada*/

import Foundation

typealias AutocompleteNewRecipes = [AutocompleteNewRecipe]

//MARK: Propiedades de la receta
struct AutocompleteNewRecipe: Hashable, Codable {
    let title: String
    let imageType: String
    let id: Int
}



