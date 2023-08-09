//
//  StepDetailTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 27/07/23.
//
//MARK: INFO:
/*Celada que muestra los pasos para realizar la celda o un mensaje en caso de que no se tengan disponibles estas instrucciones*/

import UIKit

//MARK: Delegado para mostrar las intrucciones en una pagina de internet
protocol StepDetailTableViewCellDelegate: AnyObject {
    func stepDetailTableViewCell(cell: StepDetailTableViewCell ) /***Metodo que enviara una una celad similar a esta celda para obtener su informacion***/
}

class StepDetailTableViewCell: UITableViewCell {

    
    //MARK: Outlets de la celda
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var lengthUnitLabel: UILabel!
    @IBOutlet var lengthNumberLabel: UILabel!
    @IBOutlet var stepLabel: UILabel!
    @IBOutlet var instructionsButton: UIButton!
    
    //MARK: Inicializaciones generles
    weak var delegate: StepDetailTableViewCellDelegate? /***Craemos el delegado*/
    
    
    //MARK: Actualizacion y configuracion de vista
    override func awakeFromNib() {
        super.awakeFromNib()
        instructionsButton.layer.cornerRadius = instructionsButton.bounds.height / 4 /***Redondeamos el boton de link*/
    }

    //MARK: Metodos para configurar la celda
    
    //En caso de que la receta tenga disponible las instrucciones a realizar
    func configureCell(step: Step){
        //Configuramos el numero de paso y las intrucciones
        numberLabel.text = String(step.number)
        stepLabel.text = step.step
        
        //Verificamos que el paso tenga el tiempo de la instruccion
        if step.length == nil {
            lengthNumberLabel.text = ""
            lengthUnitLabel.text = ""
        } else{
            lengthNumberLabel.text = "\(step.length!.number)"
            lengthUnitLabel.text = step.length?.unit
        }
        //Ocultamos el boton ya no se requiere
        instructionsButton.isHidden = true
    }
    
    //En caso de que la receta no tenga las intruccione a seguir pero si un link
    func configureCellWithoutInstructions(){
        //Mostramos un mensaje y un boton para que el usuario vea las instrucciones en internet
        stepLabel.text = "Read the detailed instructions on the next link"
        instructionsButton.isHidden = false
        //Ocultamos todo lo que no se requiere
        numberLabel.isHidden = true
        lengthNumberLabel.isHidden = true
        lengthUnitLabel.isHidden = true
    }
    
    //MARK: Delegado del boton para activar el delgado
    @IBAction func goToinstructionsButton(_ sender: UIButton) {
        delegate?.stepDetailTableViewCell(cell: self)
    }
    
}
