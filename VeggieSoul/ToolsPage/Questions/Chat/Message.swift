//
//  Message.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//
//MARK: INFO:
/*Creacion del modelo de la info que ocuparan los mensajes del chat*/


import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
