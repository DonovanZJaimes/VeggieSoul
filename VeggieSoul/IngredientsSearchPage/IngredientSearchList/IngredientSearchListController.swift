//
//  IngredientSearchListController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/09/23.
//

import Foundation


//MARK: estructura para obtener 10 ingredientes autocompletados de la busqueda
private var urlIngredient = "https://api.spoonacular.com/food/ingredients/autocomplete" /***URL general para esta peticion de ingredientes*/
private var generalQuery = ["intolerances": "seafood,shellfish","metaInformation" : "true" , "apiKey": "434f193f0ae24c7284fdff18938103cf" ]
struct AutocompleteIngredientWord: APIRequest {
    
    //propiedad para que recibe una palabra incompleta para recibir 20 ingredientes autocompletados de la busqueda
    let query: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["query"] = self.query /***Se establece la palabra incompleta*/
        query["number"] = "12" /***Cantidad de ingredientes autocompletados para recibir*/
        var urlComponents = URLComponents(string: urlIngredient)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 ingredientes de tipo IngredientAutocomplete
    func decodeRequest(data: Data) throws -> AutocompleteWordIngredients {
        let jsonDecoder = JSONDecoder()
        let ingredientsDecoder = try jsonDecoder.decode(AutocompleteWordIngredients.self, from: data)
        
        return ingredientsDecoder
    }
 
}


