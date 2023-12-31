//
//  IngredientDetailTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 27/07/23.
//
//MARK: INFO:
/*Celada para poder mostrar cada ingrediente de la receta, con su nombre, imagen, unidad de medida y cantidad del ingredinete*/

import UIKit

//MARK: Protocolo para realizar un delegado para selecionar el ingrediente
protocol IngredientDetailTableViewCellDelegate: AnyObject {
    func ingredientDetailTableViewCell(cell: IngredientDetailTableViewCell) /***Metodo que enviara una una celad similar a esta celda para obtener su informacion***/
}

class IngredientDetailTableViewCell: UITableViewCell {

    //MARK: Outlets de al imagen, nombre, unidad de medida y cantidad del ingrediente
    @IBOutlet var UnitOfMeasurement: UILabel!
    @IBOutlet var measureQuantityLabel: UILabel!
    @IBOutlet var ingredientNameLabel: UILabel!
    @IBOutlet var ingredientImage: UIImageView!
    //outlet del boton para seleccionar el ingrediente como completado
    @IBOutlet var addedIngredientButton: UIButton!
    
    //MARK: Inicializaciones generles
    weak var delegate: IngredientDetailTableViewCellDelegate? /***Craemos el delegado para selecionar el ingrediente*/
    
    
    //MARK: Actualizacion y configuracion de vista
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImage()
    }

    func configureImage(){
        //cofigurar el diseño de la imagen del ingrednete o receta
        ingredientImage.layer.cornerRadius = ingredientImage.frame.height / 2 /***Hacemos que la imagen de la receta tenga un redondeo en los bordes*/
        let borderColor = UIColor(named: "Opaque Separator Color")
        ingredientImage.layer.borderColor = borderColor?.cgColor /***Asignamos el color del borde*/
        ingredientImage.layer.borderWidth = 0.5 /***Asignamos el ancho del borde*/
    }
    
    
    //MARK: Actualizar los datos de la celda
    func updateCell(ingredient: RecipeIngredient, unitSystem: UnitSystem, originalPortions: Double, selectedPortions: Double){
        ingredientNameLabel.text = ingredient.name
        //Dependiendo el sistema de unidades que seleccione el usuario los datos a tomar en recipe seran diferentes
        addedIngredientButton.isSelected = ingredient.itsAdded ?? false
        
        switch unitSystem {
        case .metric:
            let measureQuantity = (ingredient.measures.metric.amount / originalPortions) * selectedPortions /***Cantdad del ingrediente en base a la cantidad de porciones que quiera el usuario*/
            measureQuantityLabel.text = measureQuantity.roundOut(numberOfDecimals: 3)
            UnitOfMeasurement.text = ingredient.measures.metric.unitShort
        case .us:
            let measureQuantity = (ingredient.measures.us.amount / originalPortions) * selectedPortions /***Cantdad del ingrediente en base a la cantidad de porciones que quiera el usuario*/
            measureQuantityLabel.text = measureQuantity.roundOut(numberOfDecimals: 3)
            UnitOfMeasurement.text = ingredient.measures.us.unitShort
        }
        
    }
    
   
    //MARK: metodo del boton para activar el delegado de la celda
    @IBAction func buttonToPressToAddIngredient(_ sender: Any) {
        delegate?.ingredientDetailTableViewCell(cell: self) /***Empezamos el delegado cuando se presione el circulo y enviamos la celda selecionada , este delegado lo realizara la vista "RecipeDetail"*/
    }
    
}


