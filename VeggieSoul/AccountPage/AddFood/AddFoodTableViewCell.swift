//
//  AddFoodTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una configuracion general de la imagen de la celda*/

import UIKit

class AddFoodTableViewCell: UITableViewCell {

    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var nameFoodLabel: UILabel!
    @IBOutlet var portionsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Hacemos que la imagen de la comida tenga un redondeo en los bordes
        foodImageView.layer.cornerRadius = foodImageView.frame.width / 2
        let borderColor = UIColor(named: "Opaque Separator Color")
        foodImageView.layer.borderColor = borderColor?.cgColor
        foodImageView.layer.borderWidth = 0.1
    }

    //MARK: Metodo para actualizar los labels de la celda
    func setUpFood(name: String, unit: String, amount: Double) {
        nameFoodLabel.text = name
        portionsLabel.text = "\(amount) " + unit
    }
    
}
