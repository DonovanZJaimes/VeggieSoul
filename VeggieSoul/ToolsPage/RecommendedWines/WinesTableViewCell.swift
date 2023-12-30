//
//  WinesTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 26/09/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda, una configuracion de la misma y metodos  para actualizar sus valores*/

import UIKit

class WinesTableViewCell: UITableViewCell {

    @IBOutlet var wineImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var averageRatingLabel: UILabel!
    @IBOutlet var ratingCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: Configurar los valores de la celda
    func updateCell(wine: RecommendedWine) {
        titleLabel.text =  wine.title
        let price = shortString(wine.price)
        priceLabel.text =  "Price: \(price)"
        let averageRating = shortDouble(wine.averageRating)
        averageRatingLabel.text = "Average Rating: \(averageRating)"
        ratingCountLabel.text = "Rating Count: \(wine.ratingCount)"
    }
   
    
    //Reduce un string a sus primeros 6 caracteres
    func shortString (_ stringPrice: String) -> String {
        guard stringPrice.count > 6 else {return stringPrice}
        var newString = stringPrice
        let range = newString.index(newString.startIndex, offsetBy: 6)..<newString.endIndex
        newString.removeSubrange(range)
        return newString
    }
    
    //Toma un double y lo regresa como un string reduciendo su longitud
    func shortDouble(_ doubleAverageRating: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let number = numberFormatter.string(from: NSNumber(value: doubleAverageRating)) else {
            fatalError("Can not get number")
        }
        return number
    
    }
    
}
