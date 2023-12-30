//
//  QuestionsController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 07/10/23.
//

import Foundation
import UIKit
//MARK: estructura para obtener respuesta de una pregunta al Chatbot
private var urlConverse = "https://api.spoonacular.com/food/converse" /***URL general para conversar con el Chatbot*/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct AskTheChatbot: APIRequest {
    
    let text: String /***Pregunta para el chatbot*/
    let contextId: String /***The conversation can contain states so you should pass your context id if you want the bot to be able to remember the conversation*/
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["text"] = self.text /***Se establece la pregunta*/
        query["contextId"] = contextId /***Id de la conversacion*/
        var urlComponents = URLComponents(string: urlConverse)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa una cantidad de 10 ingredientes de tipo IngredientAutocomplete
    func decodeRequest(data: Data) throws -> Answer {
        let jsonDecoder = JSONDecoder()
        let answerDecoder = try jsonDecoder.decode(Answer.self, from: data)
        
        return answerDecoder
    }
 
}

// MARK: Estructura para poder obtener una imagen 
struct FetchChatbotImage: APIRequest {
    //Establecemos los posibles errores al poder decodificar la imagen
    enum APIRequesError: Error {
        case imageDataMising
    }
    
    let url: String /***Se estabece el url por medio de una string***/
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest{
        let url = URL(string: url)!
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.scheme = "https"
        return URLRequest(url: urlComponents!.url!)
    }
    
    // metodo para reresar una imagen o un error en caso de que no se pueda decodificar
    func decodeRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw APIRequesError.imageDataMising
        }
        return image
    }
}
