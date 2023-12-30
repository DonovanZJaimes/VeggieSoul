//
//  RecommendedWinesController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 26/09/23.
//

import Foundation
import UIKit

//MARK: Estructura  para obtener vinos recomendados

private var urlWine = "https://api.spoonacular.com/food/wine/recommendation" /***URL general para esta peticion***/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ] /***Api Key para la api***/

struct RecommendedWinesByType: APIRequest {
    
    //propiedad para poder establecer los vinos recomendados a solicitar
    let wine: String
    let maxPrice: String
    let minRating: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["wine"] = wine /***Se establece el tipo de vino*/
        query["maxPrice"] = maxPrice /***Se establece el precio maximo*/
        query["minRating"] = minRating /***Se establece el rating minimo*/
        query["number"] = "20" /***Cantidad de vinos recomendados*/
        var urlComponents = URLComponents(string: urlWine)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //metodo que regresa una cantidad de 10 recetas con el tipo de Recipes
    func decodeRequest(data: Data) throws -> Wines {
        let jsonDecoder = JSONDecoder()
        let recipesDecoder = try jsonDecoder.decode(Wines.self, from: data)
        return recipesDecoder
    }
 
}



// MARK: Estructura para poder obtener una imagen de un vino
struct FetchWineImage: APIRequest {
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
    
    // metodopara reresar una imagen o un error en caso de que no se pueda decodificar
    func decodeRequest(data: Data) throws -> UIImage {
        guard let image = UIImage(data: data) else{
            throw APIRequesError.imageDataMising
        }
        return image
    }
}
