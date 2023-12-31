//
//  RecipeInstructions.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/07/23.
//
//MARK: INFO:
/*Informacion de las intrucciones a seguir que contendra la recta solicitada*/


import Foundation
struct RecipeInstructions: Codable {
    let steps: [Step]
}

struct Step: Codable {
    let number: Int
    let step: String
    let length: Length?
}

struct Length: Codable {
    let number: Int
    let unit: String
}
