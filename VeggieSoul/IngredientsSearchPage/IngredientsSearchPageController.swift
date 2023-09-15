//
//  IngredientsSearchPageController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 13/09/23.
//

import Foundation

//MARK: Estructura  para obtener recetas aleaorias con sus ingredientes

private var urlRecipe = "https://api.spoonacular.com/recipes/random" /***URL general para esta peticion***/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ] /***Api Key para la api***/

struct RecipeWithIngredientsAPI: APIRequest {
    
    //propiedad para poder establecer el tipo de receta a solicitar
    let type: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["tags"] = type + ",vegetarian,vegan" /***Se establece la categoria de las recetas*/
        query["number"] = "100" /***Cantidad de recetas aleatorias*/
        var urlComponents = URLComponents(string: urlRecipe)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 recetas con el tipo de Recipes
    func decodeRequest(data: Data) throws -> RecipesWithIngredients {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(RecipesWithIngredients.self, from: data)
        return recipesDecoder
    }
 
}
