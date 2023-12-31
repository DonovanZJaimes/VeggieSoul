//
//  IngredientHomeCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/06/23.
//
//MARK: INFO:
/*actualizacion y configuracion de la celda responsble de mostrar una imagen y el nombre del ingrediente*/

import UIKit

class IngredientHomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet var ingredientImage: UIImageView!
    @IBOutlet var ingredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /*Configuramos que la imagen del ingrediente tenga un redondeo en si y tambien tenga un borde de un color junto con su ancho*/
        ingredientImage.layer.cornerRadius = ingredientImage.layer.frame.width / 2
        //20 //ingredientImage.bounds.width / 2
        
        let borderColor = UIColor(named: "Opaque Separator Color") /***Color del borde*/
        ingredientImage.layer.borderColor = borderColor?.cgColor /***Asignamos el color del borde***/
        ingredientImage.layer.borderWidth = 0.05 /***Asignamos el grosor del borde*/
        
    }
    //MARK: Actualizacion de la info de la celda del ingrediente
    func SetUpIngredient(ingredient: Ingredient){
        ingredientName.text = ingredient.name
        ingredientImage.image = UIImage(systemName: "takeoutbag.and.cup.and.straw")/***Al inico asignamos una imagen de fondo para despues agregar la real del ingrediente*/
    }

}
