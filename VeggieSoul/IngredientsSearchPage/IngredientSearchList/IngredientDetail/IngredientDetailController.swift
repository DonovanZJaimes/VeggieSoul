//
//  IngredientDetailController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 19/09/23.
//

import Foundation

//MARK: INFO:
/*estructura para poder pedir un ingrediente a la API por medio de su ID*/

import Foundation


//MARK: estructura para obtener informacion de un ingrediente

//Variables para la url
private var urlIngredientPart1 = "https://api.spoonacular.com/food/ingredients/"
private var urlIngredientPart2 = "/information"
private var generalQueryIngredient = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct IngredientDetailSearch: APIRequest {
    //propiedad para que recibe el identificador unico del ingrediente
    let id: Int
    let amount: Double 
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        /*Se integran las diferentes variables privadas anteriores y su id para obtener una url*/
        var query = generalQueryIngredient
        query["amount"] = String(amount)
        let stringURL = urlIngredientPart1 + "\(id)" + urlIngredientPart2
        var urlComponents = URLComponents(string: stringURL)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa un ingrediete con su informacion
    func decodeRequest(data: Data) throws -> IngredientID {
        let jsonDecoder = JSONDecoder()
        let ingredientDecoder = try jsonDecoder.decode(IngredientID.self, from: data)
        
        return ingredientDecoder
    }
 
}
