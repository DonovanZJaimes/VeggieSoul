//
//  Recipe.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/07/23.
//
//MARK: INFO:
/*Detalles que tendra la receta al solicitarla a su API*/

import Foundation

struct RecipeDetail: Codable {
    let isVegetarian: Bool
    let likes: Int
    let credits: String
    var creditURL: String?
    let id: Int
    let nameRecipe: String
    let minutes: Int
    var servings: Int
    var image: String?
    var extendedIngredients: [RecipeIngredient]
    var nutrition: RecipeNutrition
    var instructions: [RecipeInstructions]?
    
    
    enum CodingKeys: String, CodingKey  {
        case isVegetarian = "vegetarian"
        case likes = "aggregateLikes"
        case credits = "creditsText"
        case creditURL = "sourceUrl"
        case id
        case nameRecipe = "title"
        case minutes = "readyInMinutes"
        case servings
        case image
        case extendedIngredients
        case nutrition
        case instructions = "analyzedInstructions"
        
    }
}


