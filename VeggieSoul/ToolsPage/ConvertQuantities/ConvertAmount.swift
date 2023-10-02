//
//  ConvertAmount.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/09/23.
//
//MARK: INFO:
/*Creacion del objeto para convertir cantidades con diferentes unidades*/

import Foundation

struct ConvertAmount: Codable {
    let sourceAmount: Double
    let sourceUnit: String
    let targetAmount: Double
    let targetUnit: String
    let answer: String
}
