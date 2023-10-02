//
//  SearchIngredientToToolsPageForTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/09/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una funcion para actualizar sus valores*/


import UIKit

class SearchIngredientToToolsPageForTableViewCell: UITableViewCell {

    @IBOutlet var nameIngredientLabel: UILabel!
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var aisleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpImage()
    }
    
    func setUpImage() {
        //Agregamos un borde redondeado a y color a la imagen
        ingredientImageView.layer.cornerRadius = ingredientImageView.frame.width / 2
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientImageView.layer.borderColor = borderColor?.cgColor
        ingredientImageView.layer.borderWidth = 0.4
    }

    //MARK: Metodo para actualizar los labels de la celda
    func setUpIngredient(name: String, aisle: String) {
        nameIngredientLabel.text = name
        aisleLabel.text = "    Aisle: " + aisle
    }
    
}
