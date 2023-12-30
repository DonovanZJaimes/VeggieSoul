//
//  FoodSearchListController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//

import Foundation
import UIKit


//MARK: estructura para obtener 10 ingredientes autocompletados de la busqueda
private var urlIngredient = "https://api.spoonacular.com/food/ingredients/autocomplete" /***URL general para esta peticion de ingredientes*/
private var generalQuery = ["intolerances": "seafood,shellfish","metaInformation" : "true" , "apiKey": "434f193f0ae24c7284fdff18938103cf" ]
struct AutocompleteIngredientSearch: APIRequest {
    
    //propiedad para que recibe una palabra incompleta para recibir 10 ingredientes autocompletados de la busqueda
    let query: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["query"] = self.query /***Se establece la palabra incompleta*/
        query["number"] = "10" /***Cantidad de ingredientes autocompletados para recibir*/
        var urlComponents = URLComponents(string: urlIngredient)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 ingredientes de tipo AutocompleteNewIngredient
    func decodeRequest(data: Data) throws -> AutocompleteNewIngredients{
        let jsonDecoder = JSONDecoder()
        let ingredientsDecoder = try jsonDecoder.decode(AutocompleteNewIngredients.self, from: data)
        
        return ingredientsDecoder
    }
 
}


// MARK: Estructura para poder obtener una imagen de un ingrediente
var ingredientImageUrl = "https://spoonacular.com/cdn/ingredients_250x250/" /***URL para poder pedir una imagen de un ingrediente*/

struct FetchIngredientImage: APIRequest {
    //Establecemos los posibles errores al poder decodificar la imagen
    enum APIRequesError: Error {
        case imageDataMising
    }
    
    let nameIngredient: String /***Se estabece el nombre por medio de una string***/
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest{
            let urlIngredient = URL(string: ingredientImageUrl + nameIngredient)!
            return URLRequest(url: urlIngredient)
    }
    
    // funcion para reresar una imagen o un error en caso de que no se pueda decodificar
    func decodeRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw APIRequesError.imageDataMising
        }
        return image
    }
}


//MARK: estructura para obtener 10 recetas autocompletados de la busqueda
private var urlRecipe = "https://api.spoonacular.com/recipes/autocomplete" /***URL general para esta peticion***/
private var generalQueryRecipe = ["number" : "10" , "apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct AutocompleteRecipeSearch: APIRequest {
    
    //propiedad para que recibe una palabra incompleta para recibir 10 recetas autocompletados de la busqueda
    let query: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQueryRecipe
        query["query"] = self.query /***Se establece la palabra incompleta*/
        var urlComponents = URLComponents(string: urlRecipe)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa una cantidad de 10 recetas de tipo RecipeAutocomplete
    func decodeRequest(data: Data) throws -> AutocompleteNewRecipes {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(AutocompleteNewRecipes.self, from: data)
        
        return recipesDecoder
    }
 
}


