//
//  SubstituteIngredientController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 02/10/23.
//

import Foundation
//MARK: estructura para obtener sustitutos de un ingrediente por medio de su ID
private var urlSubstitutesPart1 = "https://api.spoonacular.com/food/ingredients/" /***parte 1 de la Url para la solicitud a la API*/
private var urlSubstitutesPart2 = "/substitutes" /***parte 2 de la Url para la solicitud a la API*/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]
struct GetIngredientSubstitutesByID: APIRequest {
    
    //propiedades que recibe para realizar la peticion de red
    let id: Int
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        let query = generalQuery
        let stringID = String(id)
        let urlSubstitutes = urlSubstitutesPart1 + stringID + urlSubstitutesPart2
        var urlComponents = URLComponents(string: urlSubstitutes)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        print(urlComponents.url!)
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa los ingredientes sustitutos
    func decodeRequest(data: Data) throws -> IngredientSubstitutes {
        let jsonDecoder = JSONDecoder()
        let substitutesDecoder = try jsonDecoder.decode(IngredientSubstitutes.self, from: data)
        
        return substitutesDecoder
    }
 
}
