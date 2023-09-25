//
//  OptionsToolsPageTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 23/09/23.
//
//MARK: INFO:
/*Declaracion de outlets para la ceda, una configuracion de la misma y funciones  para actualizar sus valores*/

import UIKit

class OptionsToolsPageTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var optionImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()    }

    
    //MARK: Configurar los valores de la celda
    func updateCell (_ info : ToolOptions) {
        //Texto
        titleLabel.text = info.title
        //Imagen
        optionImageView.image = info.image
        optionImageView.layer.cornerRadius = optionImageView.frame.height / 2  /***Hacemos que la imagen tenga un redondeo en los bordes*/
        optionImageView.layer.borderColor = info.color.cgColor /***Asignamos el color del borde***/
        optionImageView.layer.borderWidth = 2 /***Asignamos el grosor del borde*/
    }
    
    
}
