//
//  EditIngredientAmountViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 09/11/23.
//
//MARK: INFO:
/*Vista para poder cambiar la cantidad de gr de un ingrediente seleccionado*/

import UIKit

//MARK: Delegado para pasar las nuevas cantidades de gr
protocol EditIngredientAmountViewControllerDelegate: AnyObject {
    //Metodo para enviar la nueva cantidad de gr del ingrediente a la vista anterior
    func editIngredientAmountViewController(_ controller: EditIngredientAmountViewController, newAmount: Int, row: Int)
}

class EditIngredientAmountViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var ingredientTitleLabel: UILabel!
    @IBOutlet var applyButton: UIButton!
    
    //MARK: Inicializaciones generles
    var newAmount: Int = 0 /***Nueva cantidad de gr del ingrediente*/
    weak var delegate: EditIngredientAmountViewControllerDelegate?
    var row: Int! /***Fila de la receta en la que se presiono en la vista anterior*/
    var ingredientFood: Food! /***Ingrediente con la informacion actual para presentarla*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        presentationController()/***Forma de presetar esta vista con  UISheetPresentationController*/
        //print(ingredientFood.name)
        setUpView()
        newAmount = Int(ingredientFood.amount)
        verifyQuantity("\(Int(ingredientFood.amount))")/***Nos ayuda a habilitar o desabilitar el boton de guardado*/

    }
     //MARK: Metodos
    //Forma de presetar esta vista con  UISheetPresentationController
    func presentationController(){
        guard let presentationController = presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium()]
        presentationController.selectedDetentIdentifier = .large
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 30
    }
    
    //Configurar los datos de la vista con a informacion de ingredientFood
    func setUpView(){
        //Configuramos los valores
        ingredientTitleLabel.text = ingredientFood.name
        amountTextField.text = "\(Int(ingredientFood.amount))"
        Task.init {
            let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: ingredientFood.image, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
            if let image = try? await sendRequest(fetchIngredientImage) {
                //Configuramos el diseño de la imagen de la receta
                ingredientImageView.image = image
                ingredientImageView.layer.cornerRadius = ingredientImageView.frame.height / 2
            }
        }
    }
    
    // Nos ayuda a habilitar o desabilitar el boton de guardado
    func verifyQuantity(_ quantity: String) {
        //Dependiendo del tipo de datos que se ingrese en el textField se podra o no guardar los nuevos gr
        switch quantity {
        case "":
            //En caso de esta vacio el textField
            errorLabel.isHidden = false
            errorLabel.text = "Enter a quantity in g"
            applyButton.isEnabled = false
        case String(newAmount):
            //En caso de no haber cambiado el valor original
            applyButton.isEnabled = false
        default:
            guard let _ = Int(quantity) else {
                //En caso de que se ingrese algo diferente a numeros
                errorLabel.isHidden = false
                errorLabel.text = "Wrong entry, integers only"
                applyButton.isEnabled = false
                return
            }
            //En caso de que se ingrese un numero diferente al original
            errorLabel.isHidden = true
            applyButton.isEnabled = true
        }
    }
    
    //MARK: Acciones
    //Modificar el TextField de la cantidad de gr
    @IBAction func modifyQuantity(_ sender: UITextField) {
        verifyQuantity(sender.text ?? "")
    }
    
    //cancelamos la posible modificacion de gr
    @IBAction func cancelQuantityModification(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    //Aplicamos la modificacion de porciones
    @IBAction func applyNewAmount(_ sender: UIButton) {
        guard let amount = Int(amountTextField.text!) else { return }
        newAmount = amount
        delegate?.editIngredientAmountViewController(self, newAmount: newAmount, row: row) /***Metodo para enviar la nueva cantidad de gr del ingrediente a la vista anterior*/
        dismiss(animated: true)
    }
    
}
