//
//  RecipeNutrition.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/07/23.
//
//MARK: INFO:
/*Informacion nutricional que contendra la recta solicitada*/

import Foundation

struct RecipeNutrition: Codable {
    var nutrients: [Flavonoid]
    var weightPerServing: Units
}


struct Flavonoid: Codable {
    let name: String
    let amount: Double
    let unit: String
    var percentOfDailyNeeds: Double?
    
}

struct Units: Codable {
    let amount: Int
    let unit: String
    
}
