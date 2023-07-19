//
//  IngredientsCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 04/07/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda, una configuracion de la misma y funciones  para actualizar sus valores dependiendo el tipo de busqueda*/

import UIKit

class IngredientAndRecipeForSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet var ingredientOrRecipeImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var buttonSearchRecipe: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cofigurar el diseño de la imagen del ingrednete o receta
        ingredientOrRecipeImage.layer.cornerRadius = 15 /***Hacemos que la imagen de la receta tenga un redondeo en los bordes*/
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientOrRecipeImage.layer.borderColor = borderColor?.cgColor /***Asignamos el color del borde*/
        ingredientOrRecipeImage.layer.borderWidth = 0.5 /***Asignamos el ancho del borde*/
    }
    
    //MARK: Actualizar los valoes en la celda en caso de que estemos buscando recetas por ingredinetes
    func setUpIngredient (ingredient: IngredientAutocomplete) {
        nameLabel.text = ingredient.name
        ingredientOrRecipeImage.image = UIImage(systemName: "takeoutbag.and.cup.and.straw")
        buttonSearchRecipe.isHidden = true /***Para buscar ingredientes no se requiere el boton, entonces se oculta*/
        
    }
    
    
    //MARK: Actualizar los valoes en la celda en caso de que estemos buscando recetas por nombre
    func setUpRecipe (recipe: RecipeAutocomplete) {
        nameLabel.text = recipe.name
        ingredientOrRecipeImage.image = UIImage(systemName: "takeoutbag.and.cup.and.straw")
        buttonSearchRecipe.isHidden = false  /***Para buscar recetas por nombre se presenta el boton para presenta la receta seleccionada*/
        
    }

}
