//
//  RecipeListByIngredientFilterViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/07/23.
//
//MARK: INFO:
/*Vista para poder presentar las opciones de filtrado para la vista de  RecipeListByIngredientViewController */

import UIKit

class RecipeListByIngredientFilterViewController: UIViewController {
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var rankingSwitch: UISwitch!
    @IBOutlet var ignorePantrySwitch: UISwitch!
    
    //MARK: Inicializaciones generales
    var numRanking: Int!
    var ignorePantry: Bool!
    weak var delegate: RecipeListByIngredientFilterViewControllerDelegate?
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController()/***Forma de presetar esta vista con  UISheetPresentationController*/
        configureSwitchs() /***Presentar el estado inicial de los switchs***/

    }
    
    func presentationController(){
        guard let presentationController = presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium()]
        presentationController.selectedDetentIdentifier = .large
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 30
    }
    
    
    func configureSwitchs() {
        /*Dependiendo de los valores de los Inicializaciones generales que son numRanking y ignorePantry se estableceran los valores de los switchs*/
        let ranking = numRanking == 1 ? true : false
        rankingSwitch.isOn = ranking
        ignorePantrySwitch.isOn = ignorePantry
    }
    
    
    @IBAction func applyFiltersButton(_ sender: Any) {
        /*Se activa el delegado al presionar el boton el cual envia la informacion para filtar las recetas de la vista anterior */
        delegate?.recipeListByIngredientFilterViewController(self, ranking: rankingSwitch.isOn, ignorePantry: ignorePantrySwitch.isOn)
        dismiss(animated: true)
    }
    
}

//MARK: Delegado para pasar la informacion para filtrar
protocol RecipeListByIngredientFilterViewControllerDelegate: AnyObject {
    func recipeListByIngredientFilterViewController(_ controller: RecipeListByIngredientFilterViewController, ranking: Bool,ignorePantry: Bool )
}
