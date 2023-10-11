//
//  Sender.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//
//MARK: INFO:
/*Creacion del modelo de la info de los integrantes del chat*/


import Foundation
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}
