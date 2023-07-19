//
//  ListRecipeDetailTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/07/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda, una configuracion de la misma y funciones  para actualizar sus valores */

import UIKit

class ListRecipeDetailTableViewCell: UITableViewCell {

    
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var ingredientsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        recipeImage.layer.cornerRadius = 15 /***Hacemos que la imagen de la receta tenga un redondeo en los bordes*/
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Actualizar los valoes en la celda en caso de que estemos buscando recetas por un tipo de categoria
    func setUpRecipeByCategory (_ recipe: RecipeByCategory) {
        recipeName.text = recipe.name
        ingredientsLabel.text = String(recipe.ingredients.count) + " Ingredients" /***Se agregan la cantidad de ingredientes tiene la receta*/
        likesLabel.text = String(recipe.likes) + " Likes" /***Se agregan la cantidad de likes que tiene la receta*/
    }
}
