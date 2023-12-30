//
//  Food.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Creacion del objeto de una comida que puede ser usada para los ingrediente o recetas*/

import Foundation

//MARK: Propiedades de la comida
struct Food: Codable, Hashable {
    let name: String
    let id: Int
    let image : String
    let units : String
    var amount: Double
}
