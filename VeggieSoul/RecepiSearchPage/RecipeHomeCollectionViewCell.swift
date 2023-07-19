//
//  RecipeHomeCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/06/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una funcion para actualizar sus valores*/
import UIKit

class RecipeHomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var ingredientsRecipe: UILabel!
    @IBOutlet var likesRecipe: UILabel!
    @IBOutlet var minutsRecipe: UILabel!
    @IBOutlet var nameRecipe: UILabel!
    @IBOutlet var imageRecipe: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRecipe.layer.cornerRadius = imageRecipe.bounds.height / 5 /***Hacemos que la imagen de la receta tenga un redondeo en los bordes*/
    }
    
    //MARK: Actualizar los valoes en la celda
    func SetUpRecipe(recipe: Recipe){
        let numIngredients = recipe.ingredients.count /***Contamos los ingredientes de la receta*/
        ingredientsRecipe.text = String(numIngredients) + " ingr"
        likesRecipe.text = String(recipe.likes)/***Likes de la receta*/
        minutsRecipe.text = String(recipe.minutes) + " min" /***Minutos de la receta*/
        nameRecipe.text = recipe.name
        imageRecipe.image = UIImage(systemName: "photo")/**Al inicio agregamos una imagen de fondo mientas se obtiene la de la receta original*/
    }
}
