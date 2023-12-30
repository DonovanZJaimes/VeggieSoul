//
//  DailyNutritionalInformation.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 05/11/23.
//
//MARK: INFO:
/*Creacion de la informacion de cada nutriente que tiene la comida, este objeto se ocupara para las tablas*/

import Foundation
//MARK: Propiedades nutrimentales de la comida consumida en el dia
struct DailyNutritionalInformation: Codable, Hashable {
    let name: String
    var amount: Float
    let unit: String
    var percentOfDailyNeeds: Double?
    
    enum CodingKeys: String, CodingKey {
        case name
        case amount
        case unit
        case percentOfDailyNeeds
    }
}

// Constante global para todos los diferentes macronutrientes que tiene la comida
let NutritionalInformationDailyMacronutrients: [DailyNutritionalInformation] = [
    DailyNutritionalInformation(name: "Calories", amount: 0, unit: "kcal", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Fat", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Trans Fat", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Saturated Fat", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Mono Unsaturated Fat", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Poly Unsaturated Fat", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Protein", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Carbohydrates", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Net Carbohydrates", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Alcohol", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Fiber", amount: 0, unit: "g", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Sugar", amount: 0, unit: "g", percentOfDailyNeeds: 0)
    
]

// Constante global para todos los diferentes micronutrientes que tiene la comida
let NutritionalInformationDailyMicronutrients: [DailyNutritionalInformation] = [
    DailyNutritionalInformation(name: "Cholesterol", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Sodium", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Caffein", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Manganese", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Potassium", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Magnesium", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Calcium", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Copper", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Zinc", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Phosphorus", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Fluoride", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Choline", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Iron", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin A", amount: 0, unit: "IU", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B1", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B2", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B3", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B5", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B6", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin B12", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin C", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin D", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin E", amount: 0, unit: "mg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Vitamin K", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Folate", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Folic Acid", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Iodine", amount: 0, unit: "µg", percentOfDailyNeeds: 0),
    DailyNutritionalInformation(name: "Selenium", amount: 0, unit: "µg", percentOfDailyNeeds: 0)
    
]

