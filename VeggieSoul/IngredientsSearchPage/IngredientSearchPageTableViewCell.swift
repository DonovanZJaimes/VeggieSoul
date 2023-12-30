//
//  IngredientSearchPageTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 13/09/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con un metodo para actualizar sus valores*/

import UIKit

class IngredientSearchPageTableViewCell: UITableViewCell {

    @IBOutlet var ingredientLabel: UILabel!
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var aisleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Metodo para actualizar los labels de la celda
    func setUpIngredient(name: String, aisle: String) {
        ingredientLabel.text = name
        aisleLabel.text = aisle
    }
}
