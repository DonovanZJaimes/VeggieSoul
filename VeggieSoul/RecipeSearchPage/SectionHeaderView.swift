//
//  SectionHeaderView.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/06/23.
//
//MARK: INFO:
/*Diseño de una vista que tendra el titulo y un boton que se ocupara para cada seccion de la vista "RecipeHome" */

import Foundation
import UIKit

//MARK: Protocolo para del boton "See All"
protocol SectionHeaderViewDelegate: AnyObject {
    /*metodo que nos servira enviar informacion del tipo de categoria que se esta selecionando para despues enviarla a la vista "RecipeList" dentro de "ByCategory"*/
    func sectionHeaderView(reusableView: SectionHeaderView)
}

class SectionHeaderView: UICollectionReusableView {
    
    weak var delegate: SectionHeaderViewDelegate? /***Creamos el delegado */
    var type: String = "type" /***Se crea la propiedad que contiene la informacion para realizar el delegado*/
    
    static let reuseIdentifier = "SectionHeaderView" /***Identificador de la vista*/
    
    //MARK: Sub vistas
    //Diseño de la vista del stackview horizontal que contendra el boton y un titulo
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution  = .fill
        stackView.alignment = .center
        return stackView
    }()

    //Diseño de a vista que contendra el titulo de la categoria de las recetas
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    //Diseño de la vista del boton que funcionara para enviarnos a otra vista
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        //button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor( UIColor(named: "ColorTeal"), for: .normal)
        button.addTarget(self, action: #selector(transitionToAllRecipes), for: .touchUpInside) /***Se crea la accion del boton para movernos a otra vista*/
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setContentHuggingPriority(.required, for: .horizontal)
        
        return button
    }()
    
    //MARK: Accion con el delegado para pasar informacion a la vista de "RecipeList- ByCategory"
    @objc func transitionToAllRecipes(){
        delegate?.sectionHeaderView(reusableView: self)/***Cundo se presione el boton comenzara a realizarse el delegado en al vista de "RecipeHome"***/
    }

    //MARK: Creacion del marco que contineen todas las subvistas anteriormente
    override init(frame: CGRect) {
        super.init(frame: frame)
        //  Se agrega la stackview
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        //Se agrega  el boton y  la label del titulo
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actualizar Titulo
    func setTitle (_ title: String){
        label.text = title /***metodo para poder asignarle el titulo a la label, este sera de la categoria y se llama en la vista de "RecipeHome"***/
    }
    
    
}
