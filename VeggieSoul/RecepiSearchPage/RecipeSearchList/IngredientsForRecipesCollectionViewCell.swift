//
//  IngredientsForRecipesCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 04/07/23.
//

//MARK: INFO:
/*Declaracion de outlets para la ceda junto con un metodo para actualizar sus valores, una accion para eliminar la celda y un protococlo con delegado para realizar la cancelacion de la celda*/

import UIKit
//MARK: Protocolo para realizar un delegado para eliminar la celda
protocol IngredientsForRecipesCollectionViewCellDelegate: AnyObject {
    func ingredientsForRecipesCollectionViewCell(collectionViewCell: IngredientsForRecipesCollectionViewCell ) /***Metodo que enviara una una celad similar a esta celda para obtener su informacion***/
    
}

class IngredientsForRecipesCollectionViewCell: UICollectionViewCell {

    @IBOutlet var ingredientImage: UIImageView!
    @IBOutlet var ingredientLabel: UILabel!
    @IBOutlet var aisleLabel: UILabel!
    
    weak var delegate: IngredientsForRecipesCollectionViewCellDelegate? /***Craemos el delegado*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Configuracion el diseño de la imagen de la receta con un redondeado, un borde de color y un ancho
        ingredientImage.layer.cornerRadius = ingredientImage.layer.frame.width //40
        
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientImage.layer.borderColor = borderColor?.cgColor
        ingredientImage.layer.borderWidth = 0.1
    }
    
    //MARK: Metodo para actualizar la inforacion de la celda
    func setUpIngredient(ingredient: IngredientAutocomplete) {
        ingredientLabel.text = ingredient.name
        aisleLabel.text = ingredient.aisle
    }

    //MARK: Accion del boton X para eliminar la celda del ingrediente
    @IBAction func eliminateIngredient(_ sender: Any) {
        delegate?.ingredientsForRecipesCollectionViewCell(collectionViewCell: self) /***Empezamos el delegado cuando se presione la X y enviamos la celda selecionada , este delegado lo realizara la vista "RecipeSearchList"*/
    }
}
