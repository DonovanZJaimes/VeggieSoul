//
//  RecipeIngredients.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/07/23.
//
//MARK: INFO:
/*DEtalles que tendra cada ingredinete de la receta obtenida*/

import Foundation
struct RecipeIngredient: Codable {
    let id: Int
    let image: String?
    let name: String
    var measures: Measures
    var itsAdded: Bool? /***Esta variable no esta dentro de la API. Se ocupara para saber si el ingrediente ya esta completo o no */
}

struct Measures: Codable {
    var us, metric: Metric
}


struct Metric: Codable {
    var amount: Double
    let unitShort, unitLong: String
}

//Enumeración de los dos sistemas de unidades disponbles al usuario
enum UnitSystem {
    case metric
    case us
}
