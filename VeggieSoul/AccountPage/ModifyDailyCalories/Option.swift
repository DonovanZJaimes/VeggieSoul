//
//  Option.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 13/12/23.
//
//MARK: INFO:
/*Creacion del objeto de una opcion de respuesta*/

import Foundation

//MARK: Propiedades de la opcion
struct Option {
    let title: String
    let description: String
    var selection: Bool
    let amount: Double
}

//MARK: Respuestas de tres preguntas diferentes
//Pregunta 1
var activityOptions: [Option] = [Option(title: "Sedentary", description: "little or no exercise", selection: false, amount: 1.2), Option(title: "Lightly active", description: "light exercise 1-3 days per week", selection: false, amount: 1.375), Option(title: "Moderately active ", description: "moderate exercise 3-5 days per week", selection: false, amount: 1.55), Option(title: "Very active", description: "intense exercise 6-7 days per week", selection: false, amount: 1.725), Option(title: "Extremely active", description: "very intense exercise, physical labor, twice a day training", selection: false, amount: 1.9)]

//Pregunta 2
var goalOptions: [Option] = [Option(title: "Weight Loss", description: "To lose weight, you need to create a caloric deficit, which means consuming fewer calories than you burn.", selection: false, amount: 0.15), Option(title: "Muscle Gain", description: "Define the caloric surplus: To gain muscle mass, you need to consume more calories than you burn", selection: false, amount: 1.075), Option(title: "Weight Maintenance", description: "Caloric balance: If your goal is to maintain your current weight, your caloric intake should be balanced with your total caloric expenditure.", selection: false, amount: 1)]

//Pregunta 3
var nutrientsDistributionOptions: [Option] = [Option(title: "Moderate Balance", description: "This approach provides a balance between the three macronutrients", selection: false, amount: 433), Option(title: "High-Protein Diet", description: "Recommended for those looking to increase muscle mass or preserve it during weight loss", selection: false, amount: 343), Option(title: "Low-Carbohydrate Approach", description: "Useful for those who respond well to low-carbohydrate diets", selection: false, amount: 244), Option(title: "High-Energy Focus", description: "Ideal for endurance athletes and individuals with very high caloric needs.", selection: false, amount: 532), Option(title: "Ketogenic Diet", description: "Designed to bring the body into a state of ketosis, where it burns fats instead of carbohydrates for energy. ", selection: false, amount: 127)]
