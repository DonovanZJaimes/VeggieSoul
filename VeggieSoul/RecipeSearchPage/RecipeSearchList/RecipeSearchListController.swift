//
//  RecipeSearchListController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 03/07/23.
//

//MARK: INFO:
/*Estrcuturas para solicitudes de red para la vista "RecipeSearchList" */

import Foundation
import UIKit


//MARK: estructura para obtener 10 ingredientes autocompletados de la busqueda
private var urlIngredient = "https://api.spoonacular.com/food/ingredients/autocomplete" /***URL general para esta peticion de ingredientes*/
private var generalQuery = ["intolerances": "seafood,shellfish","metaInformation" : "true" , "apiKey": "434f193f0ae24c7284fdff18938103cf" ]
struct AutocompleteIngredient: APIRequest {
    
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
    
    //metodo que regresa una cantidad de 10 ingredientes de tipo IngredientAutocomplete
    func decodeRequest(data: Data) throws -> IngredientsAutocomplete {
        let jsonDecoder = JSONDecoder()
        let ingredientsDecoder = try jsonDecoder.decode(IngredientsAutocomplete.self, from: data)
        
        return ingredientsDecoder
    }
 
}



//MARK: Estructura para poder obtener info de un solo ingrediente
//Solo se recibe la informacion del ingrediente que se selecciono en la vista de "RecipeHome"
private var urlForIngredientPart1 = "https://api.spoonacular.com/food/ingredients/"
private var urlForIngredientPart2 = "/information?amount=1"
private var IngredientQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct InformationOfAnIngredient: APIRequest {
   
    let id: Int
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        let urlString = urlForIngredientPart1 + String(id) + urlForIngredientPart2 /***Se agrega el id dentro de la URl*/
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = IngredientQuery.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa un ingrediente de tipo IngredientAutocomplete
    func decodeRequest(data: Data) throws -> IngredientAutocomplete {
        let jsonDecoder = JSONDecoder()
        let ingredientsDecoder = try jsonDecoder.decode(IngredientAutocomplete.self, from: data)
        return ingredientsDecoder
    }
    
}


//MARK: estructura para obtener 10 recetas autocompletados de la busqueda
private var urlRecipe = "https://api.spoonacular.com/recipes/autocomplete" /***URL general para esta peticion***/
private var generalQueryRecipe = ["number" : "10" , "apiKey": "434f193f0ae24c7284fdff18938103cf" ]

struct AutocompleteRecipe: APIRequest {
    
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
    
    //metodo que regresa una cantidad de 10 recetas de tipo RecipeAutocomplete
    func decodeRequest(data: Data) throws -> RecipesAutocomplete {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(RecipesAutocomplete.self, from: data)
        
        return recipesDecoder
    }
 
}


// MARK: Estructura para poder obtener una imagen de la  receta por su ID

private var urlRecipeImage = "https://spoonacular.com/recipeImages/" /***URL general para esta peticion***/
private var sizeImage = "90x90" /***Tamaño de la imagen de la receta*/
struct FetchRecipeImageID: APIRequest {
    //Establecemos los posibles errores al poder decodificar la imagen
    enum APIRequesError: Error {
        case imageDataMising
    }
    
    let id: String /***Se estabece el  ID de la receta***/
    let type: String /***Se estabece el  tipo de imagen como: .jpg***/
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest{
        let ulrString = urlRecipeImage + id + "-" + sizeImage + "." + type
        let url = URL(string: ulrString)!
        return URLRequest(url: url)
    }
    
    // metodo para reresar una imagen o un error en caso de que no se pueda decodificar
    func decodeRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw APIRequesError.imageDataMising
        }
        return image
    }
}
