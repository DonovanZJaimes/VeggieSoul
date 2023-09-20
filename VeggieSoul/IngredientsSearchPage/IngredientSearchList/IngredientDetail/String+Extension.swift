//
//  String+Extension.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/09/23.
//
//MARK: INFO:
/*Extension de String para modificar alguna letra*/

import Foundation

extension String {
    /*Funcion para poder convertir la primera letra del string en mayuscula*/
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
