//
//  IngredientRecipeListCollectionViewCell.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INF:
/*Declaracion de outlets para la ceda junto con una funcion para actualizar sus valores, una accion para eliminar la celda y un protococlo con delegado para realizar la cancelacion de la celda*/


import UIKit
//MARK: Protocolo para eliminar ingredinete por medio del boton X
protocol IngredientRecipeListCollectionViewCellDelegate:AnyObject {
    func ingredientRecipeListCollectionViewCell(_ controller: IngredientRecipeListCollectionViewCell) /***Metodo que enviara una una celad similar a esta celda para obtener su informacion***/
}

class IngredientRecipeListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var buttonToCancelIngredient: UIButton!
    @IBOutlet var stackview: UIStackView!
    @IBOutlet var ingredientImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell() /***Configurar la celda***/
    }
    
    weak var delegate: IngredientRecipeListCollectionViewCellDelegate? /***Instanciamos el protocolo del delegado*/
    
    //MARK: Configurar la celda
    func setUpCell() {
        //Configuracion el diseño de la imagen del ingrediente con un redondeado, un borde de color y un ancho
        ingredientImage.layer.cornerRadius = stackview.frame.size.height / 9
        
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientImage.layer.borderColor = borderColor?.cgColor
        ingredientImage.layer.borderWidth = 0.1
        ingredientImage.image = UIImage(systemName: "takeoutbag.and.cup.and.straw")
    }
    
    //MARK: Metodo para actualizar la inforacion de la celda
    func setUpIngredient(ingredient: IngredientRecipeList, image: UIImage?) {
        nameLabel.text = ingredient.name
        ingredientImage.image = image
        
    }
    //MARK: Presionar boton X para borrar ingrediente
    @IBAction func toCancelIngredient(_ sender: UIButton) {
        delegate?.ingredientRecipeListCollectionViewCell(self) /***Se activa el delegado en cuando se presione el boton de x, este delegado lo realizara la vista "RecipeListByIngredient"*/
    }
    
    
}
