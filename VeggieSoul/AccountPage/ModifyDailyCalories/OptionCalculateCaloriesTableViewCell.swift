//
//  OptionCalculateCaloriesTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 12/12/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda junto con una configuracion para presionar un boton*/

import UIKit

//MARK: Delegado para seleccionar el boton de la celda
protocol OptionCalculateCaloriesTableViewCellDelegate: AnyObject {
    func optionCalculateCaloriesTableViewCell(_ cell: OptionCalculateCaloriesTableViewCell) /***Metodo que enviara una una celad similar a esta celda para obtener su informacion***/
}

class OptionCalculateCaloriesTableViewCell: UITableViewCell {

    @IBOutlet var optionSelectionButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    weak var delegate: OptionCalculateCaloriesTableViewCellDelegate? /***Creamos el delegado*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //Pasamos la celda del boton presionado
    @IBAction func optionSelection(_ sender: UIButton) {
        delegate?.optionCalculateCaloriesTableViewCell(self)
    }
    
    //configuracion de los labels y boton de la celda
    func updateCell(option: Option, isSelected: Bool){
        optionSelectionButton.isSelected = option.selection
        titleLabel.text = option.title
        descriptionLabel.text = option.description
        optionSelectionButton.isSelected = isSelected
    }
    
    
}
