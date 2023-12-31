//
//  RecipeHomeController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/06/23.
//
//MARK: INFO:
/*Estrcuturas para solicitudes de red para la vista "RecipeHome y tambien la creacion de un generico" */

import Foundation
import UIKit

//MARK: Protocolo para realizar peticiones de red
protocol APIRequest {
    /*Para realizar solicitudes de red y que etas sean mas cortas se creara un protocolo para que adopten esta propiedad y metodo que funciona para las proximas solicitudes de red de tipo GET*/
    associatedtype Response
    
    var urlRequest: URLRequest {get}/***La estructura que adopte este protocolo tendra que devolver una URL para solicitar la informacion*/
    func decodeRequest (data: Data) throws -> Response /***metodoque obiene la data de la metodo URLSession y regresa el tipo de objeto solicitado ***/
}
//MARK: Errores para el generico para peticiones de red
enum APIRequestError: Error {
    case RecipeNotFound /***En caso de que no se puedan obtener recetas o que los puntos que permite la API se agoten***/
    case imageDataMising /***En caso de que no se puede obtener la imagen ***/
}

//MARK: Metodo generico para relizar solicitudes de red
/*El metodo tiene un parametro Request y este debe adoptar el protocolo APIRequest*/
func sendRequest <Request: APIRequest> (_ request: Request ) async throws -> Request.Response {
    let (data, response) = try await URLSession.shared.data(for: request.urlRequest)/***Realizamos la solicitud de red  usando una propiedad que tiene el parametro del metodo*/
    
    //Se verifica que se obtuvo la info adecuada
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
              throw APIRequestError.RecipeNotFound
          }
    //Se obtine el objeto usando un metodo del parametro del metodo sendRequest
    let decodeResponse = try request.decodeRequest(data: data) /***Este motodo regresa el objeto solicitado*/
    return decodeResponse
}

//MARK: Estructura  para obtener recetas aleaorias de una categoria

private var urlRecipe2 = "https://api.spoonacular.com/recipes/random" /***URL general para esta peticion***/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ] /***Api Key para la api***/

struct RecepiByType: APIRequest {
    
    //propiedad para poder establecer el tipo de receta a solicitar
    let type: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["tags"] = type + ",vegetarian" /***Se establece la categoria de las recetas*/
        query["number"] = "100" /***Cantidad de recetas aleatorias*/
        var urlComponents = URLComponents(string: urlRecipe2)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa una cantidad de 10 recetas con el tipo de Recipes
    func decodeRequest(data: Data) throws -> Recipes {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(Recipes.self, from: data)
        return recipesDecoder
    }
 
}

// MARK: Estructura para poder obtener una imagen de la  receta
struct FetchRecipeImage: APIRequest {
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


// MARK: Estructura para poder obtener una imagen de un ingrediente o equipo de cocina
var urlForIngredient = "https://spoonacular.com/cdn/ingredients_250x250/" /***URL para poder pedir una imagen de un ingrediente*/
var urlForEquipment = "https://spoonacular.com/cdn/equipment_100x100/" /***URL para poder pedir una imagen de un equipo de cocina*/

struct FetchIngredienOrEquipmentImage: APIRequest {
    //Establecemos los posibles errores al poder decodificar la imagen
    enum APIRequesError: Error {
        case imageDataMising
    }
    
    let nameOfIngredientOrEquipment: String /***Se estabece el nombre por medio de una string***/
    let isIngredient: Bool /***Se verifica si la peticion sera para un ingrediente o para un equipo*/
    

    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest{
        if isIngredient {
            //En el caso que la solicitud sea para un ingrediente
            let urlIngredient = URL(string: urlForIngredient + nameOfIngredientOrEquipment)!
            return URLRequest(url: urlIngredient)
        } else {
            //En el caso que la solicitud sea para un equipo de cocina
            let urlEquipment = URL(string: urlForEquipment + nameOfIngredientOrEquipment)!
            return URLRequest(url: urlEquipment)
        }
    }
    
    // metodo para reresar una imagen o un error en caso de que no se pueda decodificar
    func decodeRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw APIRequesError.imageDataMising
        }
        return image
    }
}
