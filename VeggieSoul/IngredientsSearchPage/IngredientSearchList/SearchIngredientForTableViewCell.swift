//
//  SearchIngredientForTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/09/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una funcion para actualizar sus valores*/


import UIKit

class SearchIngredientForTableViewCell: UITableViewCell {

    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var nameIngredientLabel: UILabel!
    @IBOutlet var aisleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Hacemos que la imagen de la receta tenga un redondeo en los bordes
        ingredientImageView.layer.cornerRadius = ingredientImageView.frame.width / 2
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientImageView.layer.borderColor = borderColor?.cgColor
        ingredientImageView.layer.borderWidth = 0.1
    }

    
    //MARK: Metodo para actualizar los labels de la celda
    func setUpIngredient(name: String, aisle: String) {
        nameIngredientLabel.text = name
        aisleLabel.text = "    " + aisle
    }
    
}
