//
//  AnswerMedia.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//
//MARK: INFO:
/*Creacion del modelo de la info que ocuparan las respuestas del Chatbot en caso que tenga media */


import Foundation

struct AnswerMedia: Codable {
    let title: String?
    let image: String?
    let link: String?
}
