//
//  RecipeAndIngredientsTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 31/10/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una configuracion de labels y su imagen*/

import UIKit

class RecipeAndIngredientsTableViewCell: UITableViewCell {

    @IBOutlet var recipeOrIngredientImage: UIImageView!
    @IBOutlet var recipeOrIngredientLabel: UILabel!
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var amountRecipeOrIngredientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }
    
    //Configuracion de la imagen
    func setUpCell(){
        recipeOrIngredientImage.layer.cornerRadius = recipeOrIngredientImage.frame.width / 2
        let borderColor = UIColor(named: "Opaque Separator Color")
        recipeOrIngredientImage.layer.borderColor = borderColor?.cgColor
        recipeOrIngredientImage.layer.borderWidth = 0.1
    }

    //configuracion si la celda presenta una receta
    func updateLabelsForRecipe(name: String, portions: Int16){
        recipeOrIngredientLabel.text = name
        let portion = portions > 1 ? "Portions" : "Portion"
        amountRecipeOrIngredientLabel.text = "\(portions) " + portion
    }
    
    //configuracion si la celda presenta un ingrediente
    func updateLabelsForIngredient (name: String, portions: Int16){
        recipeOrIngredientLabel.text = name
        amountRecipeOrIngredientLabel.text = "\(portions) g"
        
    }
    
    //Mostar el boton
    func showAccessory(){
        plusButton.isHidden = true
        self.accessoryType = .disclosureIndicator
    }
    //Ocultar el boton
    func  hiddenAccessory(){
        plusButton.isHidden = false
        self.accessoryType = .none
    }
    
    @IBAction func searchForNewFood(_ sender: UIButton) {
    }
    
}
