//
//  RecipeListByCategoryFilterViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/07/23.
//
//MARK: INFO:
/*Vista para poder presentar las opciones de filtrado para la vista de  RecipeListByCategoryViewController */


import UIKit


class RecipeListByCategoryFilterViewController: UIViewController {
    
    //MARK: definir Outlets del Storyboard e inicializaciones generales
    @IBOutlet var containerViewTableView: UIView!
    @IBOutlet var applyButton: UIButton!
    weak var delegate: RecipeListByCategoryFilterViewControllerDelegate?
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        /*Forma de presetar esta vista con  UISheetPresentationController*/
        guard let presentationController = presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium()]
        presentationController.selectedDetentIdentifier = .large
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 30
        
    }
    
    @IBAction func applyFiltersButton(_ sender: Any) {
        /*Se activa el delegado al presionar el boton el cual envia la informacion para filtar las recetas de la vista anterior */
        delegate?.recipeListByCategoryFilterViewController(self, typeOfMealsSelected: VariablesFilterRecipes.shared.typeOfMealsSelected, typeOfDietSelected: VariablesFilterRecipes.shared.typeOfDietSelected)
        
        dismiss(animated: true)
    }
}


//MARK: Delegado para pasar la informacion para filtrar
protocol RecipeListByCategoryFilterViewControllerDelegate: AnyObject {
    func recipeListByCategoryFilterViewController (_ controller: RecipeListByCategoryFilterViewController, typeOfMealsSelected: [String], typeOfDietSelected: String )
}
