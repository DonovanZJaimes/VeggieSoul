//
//  RecipeDetailController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/07/23.
//
//MARK: INFO:
/*estructura para poder pedir una receta a la API por medio de su ID*/

import Foundation


//MARK: estructura para obtener informacion de la receta

//Variables para la url
private var urlRecipePart1 = "https://api.spoonacular.com/recipes/"
private var urlRecipePart2 = "/information"
private var generalQueryRecipe = ["includeNutrition": "true", "apiKey": "434f193f0ae24c7284fdff18938103cf" ]


struct RecipeDetailSearch: APIRequest {
    //propiedad para que recibe el identificador unico de la receta
    let id: Int
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        /*Se integran las diferentes variables privadas anteriores y su id para obtener una url*/
        let stringURL = urlRecipePart1 + "\(id)" + urlRecipePart2
        var urlComponents = URLComponents(string: stringURL)!
        urlComponents.queryItems = generalQueryRecipe.map {URLQueryItem(name: $0.key, value: $0.value)}
        print(urlComponents.url!)
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa una receta con su informacion
    func decodeRequest(data: Data) throws -> RecipeDetail {
        let jsonDecoder = JSONDecoder()
        let recipeDecoder = try jsonDecoder.decode(RecipeDetail.self, from: data)
        
        return recipeDecoder
    }
 
}
