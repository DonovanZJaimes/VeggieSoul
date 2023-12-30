//
//  ListRecipeDetailCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda, una configuracion de la misma y metodos  para actualizar sus valores dependiendo de la receta recibida*/

import UIKit

class ListRecipeDetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeName: UILabel!
    @IBOutlet var ingredientsLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()/***Configuramos la celda*/
    }
    
    //MARK: Actualizar la celda
    func setUpCell() {
        recipeImage.layer.cornerRadius = 15 /***Hacemos que la imagen de la receta tenga un redondeo en los bordes*/
    }
    
    //MARK: Actualizar los valoes en la celda en caso de que estemos buscando recetas por ingredinetes
    func setUpRecipeByIngredient (_ recipe: RecipeByIngredient) {
        recipeName.text = recipe.name
        ingredientsLabel.text = String(recipe.ingredientsCount) + " Ingredients" /***Agregamos el numero de ingredientes  de la receta*/
        likesLabel.text = String(recipe.likes) + " Likes" /***Agregamos el numero de ilikes  de la receta*/
    }
    /*
    func setUpRecipeByCategory (_ recipe: RecipeByCategory) {
        recipeName.text = recipe.name
        ingredientsLabel.text = String(recipe.ingredients.count) + " Ingredients"
        likesLabel.text = String(recipe.likes) + " Likes"
    }*/

}
