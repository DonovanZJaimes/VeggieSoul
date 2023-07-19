//
//  LineView.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/06/23.
//

import Foundation
import UIKit
//MARK: INFO:
/*Creacion de una vista que servira como separador en las categorias de la vista "RecipeHome"*/

class LineView: UICollectionReusableView {
    
    static let reuseIdentifier = "LineView" /***Agregamos un identificador para la vista***/
    
    //MARK: Creacion del marco de la vista
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Funcion para cambiar el color de la inea de separacion
    func setColor(_ color: UIColor) {
        backgroundColor = color
    }
    
}
