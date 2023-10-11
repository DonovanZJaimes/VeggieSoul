//
//  Answer.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//
//MARK: INFO:
/*Creacion del modelo de la info de la respuesta del Chatbot */


import Foundation


struct Answer: Codable {
    let answerText: String
    let media: [AnswerMedia]
}
