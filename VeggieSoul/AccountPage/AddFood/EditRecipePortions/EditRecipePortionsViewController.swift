//
//  EditRecipePortionsViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 09/11/23.
//
//MARK: INFO:
/*Vista para poder cambiar la cantidad de porciones de una receta seleccionada*/

import UIKit

//MARK: Delegado para pasar las nuevas cantidades de porciones
protocol EditRecipePortionsViewControllerDelegate: AnyObject {
    //Metodo para enviar la nueva cantidad de porciones de la receta a la vista anterior
    func editRecipePortionsViewController(_ controller: EditRecipePortionsViewController, newAmount: Int, row: Int)
}

class EditRecipePortionsViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var portionsLabel: UILabel!
    @IBOutlet var portionsStepper: UIStepper!
    @IBOutlet var recipeImageView: UIImageView!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var recipeTitleLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    
    //MARK: Inicializaciones generles
    var recipeFood: Food! /***Receta con la informacion actual para presentarla*/
    var newAmount: Int = 0 /***Nueva cantidad de porciones de la receta*/
    weak var delegate: EditRecipePortionsViewControllerDelegate?
    var row: Int! /***Fila de la receta en la que se presiono en la vista anterior*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController()/***Forma de presetar esta vista con  UISheetPresentationController*/
        //print(recipeFood.name)
        setUpView()
        newAmount = Int(recipeFood.amount)
        verifyQuantity("\(Int(recipeFood.amount))") /***Nos ayuda a habilitar o desabilitar el boton de guardado*/
    }
    
    //Forma de presetar esta vista con  UISheetPresentationController
    func presentationController(){
        guard let presentationController = presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium()]
        presentationController.selectedDetentIdentifier = .large
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 30
    }

    //Configurar los datos de la vista con a informacion de recipeFood
    func setUpView(){
        //Configuramos los valores
        portionsStepper.value = recipeFood.amount
        recipeTitleLabel.text = recipeFood.name
        portionsLabel.text = "\(Int(recipeFood.amount)) Portions"
        Task.init {
            let fetchRecipeImageID = FetchRecipeImageID(id: String(recipeFood.id) , type: recipeFood.image)
             /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
            if let image = try? await sendRequest(fetchRecipeImageID) {
                //Configuramos el diseño de la imagen de la receta
                recipeImageView.image = image
                recipeImageView.layer.cornerRadius = recipeImageView.frame.height / 2
            }
        }
    }
    
    //Nos ayuda a habilitar o desabilitar el boton de guardado
    func verifyQuantity(_ quantity: String) {
        if recipeFood.amount == portionsStepper.value {
            applyButton.isEnabled = false
        } else {
            applyButton.isEnabled = true
        }
    }
    
    //MARK: Acciones
    //modificar el UIStepper
    @IBAction func changedPortions(_ sender: UIStepper) {
        portionsLabel.text = "\(Int(sender.value)) Portions"
        verifyQuantity("\(sender.value)") /***Nos ayuda a habilitar o desabilitar el boton de guardado*/
    }
    
    //cancelamos la posible modificacion de porciones
    @IBAction func cancelQuantityModificatio(_ sender: UIButton) {
        dismiss(animated: true)
    }

    //Aplicamos la modificacion de porciones
    @IBAction func applyNewAmount(_ sender: UIButton) {
        newAmount = Int(portionsStepper.value)
        delegate?.editRecipePortionsViewController(self, newAmount: newAmount, row: row) /***Metodo para enviar la nueva cantidad de porciones de la receta a la vista anterior*/
        dismiss(animated: true)
    }
    
}
