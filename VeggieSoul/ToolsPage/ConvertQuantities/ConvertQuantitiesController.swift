//
//  ConvertQuantitiesController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/09/23.
//

import Foundation
//MARK: estructura para obtener la equivalencia de cantidades de un ingrediente con sus respectivas unidades
private var urlConvert = "https://api.spoonacular.com/recipes/convert" /***URL general para esta peticion de ingredientes*/
private var generalQuery = ["apiKey": "434f193f0ae24c7284fdff18938103cf" ]
struct ConversionUnitsOfAnIngredient: APIRequest {
    
    //propiedades que recibe para realizar la peticion de red
    let ingredientName: String
    let sourceAmount: Double
    let sourceUnit: String
    let targetUnit: String
    
    //Regresa una URL para realizar la solicitud
    var urlRequest: URLRequest {
        var query = generalQuery
        query["ingredientName"] = ingredientName /***Se establece el nombre del ingrediente*/
        query["sourceAmount"] = String(sourceAmount) /***Cantidad del ingrediente para recibir*/
        query["sourceUnit"] = sourceUnit /***Tipo de unidad a enviar*/
        query["targetUnit"] = targetUnit /***Tipo de unidad a recibir*/
        var urlComponents = URLComponents(string: urlConvert)!
        urlComponents.queryItems = query.map {URLQueryItem(name: $0.key, value: $0.value)}
        return URLRequest(url: urlComponents.url!)
    }
    
    //Funcion que regresa la unidad equivalente a la cantidad enviada
    func decodeRequest(data: Data) throws -> ConvertAmount {
        let jsonDecoder = JSONDecoder()
        let amountDecoder = try jsonDecoder.decode(ConvertAmount.self, from: data)
        
        return amountDecoder
    }
 
}
