//
//  UIView+Extension.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/09/23.
//
//MARK: INFO:
/*extension con funcion para situar una vista dentro de otra en en sus limites */

import Foundation
import UIKit

extension UIView {
    func pin(to superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
        
    }
}
