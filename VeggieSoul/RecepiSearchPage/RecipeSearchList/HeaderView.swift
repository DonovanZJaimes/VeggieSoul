//
//  HeaderView.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 03/07/23.
//

import Foundation
import UIKit

//MARK: INFO:
/*Diseño de una vista que tendra el titulo  que se ocupara para cada seccion de la vista "RecipeSearchList" */
class HeaderView: UICollectionReusableView {
    
    static let reuseIdentifier = "HeaderView" /***Identificador de la vista*/
    
    //MARK: Sub vistas
    //Diseño de la vista del stackview horizontal que contendra el  titulo y posiblemente un conteo
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    
    //Diseño de a vista que contendra el titulo del tipo de busqueda que se este realizando o inforcacion que se presente
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    
    //MARK: Creacion del marco que contineen todas las subvistas anteriormente
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        //Por el momento solo se agrego el titulo
        stackView.addArrangedSubview(label)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actualizar Titulo
    func setTitle (_ title: String){
        label.text = title /***Funcion para poder asignarle el titulo a la label, este sera del tipo de busqueda y se llama en la vista de "RecipeSearchList"***/
    }
    
    
}


