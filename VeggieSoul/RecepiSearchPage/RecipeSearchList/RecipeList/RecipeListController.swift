//
//  RecipeListController.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Estrcuturas para solicitudes de red para la vista "RecipehListByCategory" y "RecipehListByIngredient"*/

import Foundation


//MARK: estructura para obtener 100 recetas aleatorias de una categoria con sus respectivos filtros
private var urlRecipeRandom = "https://api.spoonacular.com/recipes/random" /***URL general para esta peticion de recetas aleatorias*/
private var apiKeyByRandom = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct RecepiByTypeAndTags: APIRequest {
    
    //propiedade para poder establecer el tipo de recetas a solicitar
    let type: String
    let diet: [String]
    let intolerances: [String]?
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        //let stringDiet = diet.joined(separator: ",")
        //let stringIntolerances = intolerances?.joined(separator: ",")
        var query = apiKeyByRandom
        //let tags = type + "," + stringDiet  + "," + (stringIntolerances ?? "seafood,shellfish")
        let tags = performTags(diet: diet, intolerances: intolerances, type: type)
        query["tags"] = tags /***Se establece los tags de las recetas*/
        query["number"] = "10" /***Cantidad de recetas aleatorias*/
        //print(query)
        var urlComponents = URLComponents(string: urlRecipeRandom)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 recetas con el tipo de Recipes
    func decodeRequest(data: Data) throws -> RecipesByCategory {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(RecipesByCategory.self, from: data)
        return recipesDecoder
    }
 
}
//MARK: Metodo que regresa un string formateado
private func performTags(diet: [String], intolerances: [String]?, type: String) -> String{
    let stringDiet = diet.joined(separator: ",")/***Para todos los tipo de dietas se juntaran con una ","*/
    let stringIntolerances = intolerances?.joined(separator: ",") /***Para todos los tipo de intoleracias se juntaran con una ","*/
    let tags = type + "," + stringDiet  + "," + (stringIntolerances ?? "") /***Se creara un string con el tipo de categoria, dietas e intoleracias para poder pedir una solicitud de red*/
    return tags
}



//MARK: estructura para obtener recetas por los igredientes selecionados con sus respectivos filtros
private var urlRecipeByIngredients = "https://api.spoonacular.com/recipes/findByIngredients" /***URL general para esta peticion de recetas por ingredientes selecionados*/
private var apiKeyByIngredients = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct RecipeByIngredents: APIRequest {
    
    //propiedades para poder establecer el tipo de recetas a solicitar
    let ingredients: String
    //let ranking: Int
    //let ignorePantry: Bool
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        //let stringIngredients = ingredients.joined(separator: ",+")
        var query = apiKeyByIngredients
        //query["ignorePantry"] = String(ignorePantry)
        //query["ranking"] = String(ranking) /***Ya sea para maximizar los ingredientes usados ​​(1) o minimizar los ingredientes faltantes (2) primero*/
        query["ingredients"] = ingredients /***Se establece la lista de los ingredientes */
        query["number"] = "3" /***Cantidad de recetas solicitadas*/
        var urlComponents = URLComponents(string: urlRecipeByIngredients)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 recetas con el tipo de Recipes
    func decodeRequest(data: Data) throws -> RecipesByIngredient {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(RecipesByIngredient.self, from: data)
        return recipesDecoder
    }
 
}



