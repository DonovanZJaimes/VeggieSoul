//
//  ConvertQuantitiesViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 24/09/23.
//
/*Se presenta la forma de poder tener la equivalencia de cantidades de in ingrediente con diferentes unidades de medicion*/

import UIKit
import Lottie

class ConvertQuantitiesViewController: UIViewController {

    //MARK: definir Outlets del Storyboard
    @IBOutlet var nameIngredientLabel: UILabel!
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var sourceAmountTextField: UITextField!
    @IBOutlet var sourceAmountAsteriskLabel: UILabel!
    @IBOutlet var sourceUnitTextField: UITextField!
    @IBOutlet var sourceUnitAsteriskLabel: UILabel!
    @IBOutlet var targetUnitTextField: UITextField!
    @IBOutlet var targetUnitAsteriskLabel: UILabel!
    @IBOutlet var convertAmountButton: UIButton!
    @IBOutlet var answerLabel: UILabel!
    
    //MARK: Inicializaciones generales
    var sourceAmount: Double = 2.5 /***Valor inicial y que se ocupara para el texto del TextField de Amount*/
    var nameIngredient: String = "apple" /***Valor inicial y variable que se ocupara para hacer la solicitud de red*/
    var possibleUnits: [String] = ["small", "large", "piece", "slice", "g", "extra small", "medium", "oz","cup slice","cup", "serving"] /***Valor inicial para la entrada del PickerView*/
    var imageUrl: String = "apple.jpg"
    var possibleUnitsPickerView = UIPickerView() /***Picker view para mostrar las posibles unidades del ingrediente*/
    let searchController = UISearchController(searchResultsController: IngredientSearchListToToolsPageViewController())
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchController() /***Actualizamos el search controller para poder hacer las busquedas*/
        setUpNavigationItem () /***Configuramos el titulo al inicio de la vista***/
        updateIngredient(name: nameIngredient, image: imageUrl) /***Configuramos la vista inicial con valores predeterminados*/
        setUpPickerView()/***asignar el delegado y dataSource para el pickerView**/
        setUpTextFields() /***Asignamos el tipo de entrada a los TextField */
        updateButton() /***Configuramos el estilo del boton de convertir cantidades*/
        updateImage() /***Configuramos el estilo de la imagen del ingrediente*/

    }
    
    //MARK: Actualizar el search Controller
    func setUpSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Ingredients"
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpNavigationItem (){
        //Titulo
        navigationItem.title = "Convert Quantities"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Tools", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }

    //MARK: Actualizamos la vista con la informacion del ingrediente
    func updateIngredient(name: String, image: String) {
        //Configuramos el nombre e imagen
        nameIngredientLabel.text = name
        requestImageIngredient(imageURl: image)
        //Configuramos los asteriscos de erros de cada TextField
        sourceAmountAsteriskLabel.isHidden = true
        sourceUnitAsteriskLabel.isHidden = true
        targetUnitAsteriskLabel.isHidden = true
    }
    
    //Solicitamos la imagen del ingrediente
    func requestImageIngredient(imageURl: String) {
        let fetchIngredienOrEquipmentImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: imageURl, isIngredient: true)
        Task {
            /*Solicitamos la imagen del ingrediente a la API*/
            if let image = try? await sendRequest(fetchIngredienOrEquipmentImage){
                ingredientImageView.image = image /***Agregamos la imagen obtenida a la imageView*/
            }
        }
    }
    
    //MARK: Configurar la picker view
    func setUpPickerView() {
        //asignar el delegado y dataSource para el pickerView
        possibleUnitsPickerView.delegate = self
        possibleUnitsPickerView.dataSource = self
    }
    
    //MARK: Configurar el TextField del vino a selecionar
    func setUpTextFields() {
        //Asignamos el tipo de entrada a los dos TextField con un pickerView
        sourceUnitTextField.inputView = possibleUnitsPickerView
        targetUnitTextField.inputView = possibleUnitsPickerView
        //Asgnamos el textField de Amount con tipo de teclado
        sourceAmountTextField.keyboardType = .numbersAndPunctuation
        sourceAmountTextField.resignFirstResponder()
    }
    
    //MARK: Configuramos el estilo del boton de convertir cantidades
    func updateButton() {
        convertAmountButton.layer.cornerRadius = convertAmountButton.frame.height / 3
    }
    //MARK: Configurar el estilo de la imagen
    func updateImage() {
        // Hacemos que la imagen del ingrediente tenga un redondeo en los bordes
        ingredientImageView.layer.cornerRadius = ingredientImageView.frame.width / 2
    }
    
    
    @IBAction func editingSourceAmount(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    //MARK: Apretar el boton para convertir la cantidad del  ingreiente a otra
    @IBAction func requestToChangeUnitQuantity(_ sender: UIButton) {
        verifyFillingTextFields() /***Verificar si el llenado de las textFiels es correcto*/
        //Verificar si se puede realizar una solicitud a la API
        if let amount = Double(sourceAmountTextField.text!), targetUnitTextField.text?.isEmpty == false, sourceUnitTextField.text?.isEmpty == false {
            requestUnitChange(amount: amount)/***Realizar una solicitud a la API*/
        }
    }
    
    //Verificar si el llenado de las textFiels es correcto
    func verifyFillingTextFields() {
        //Mostrar u ocultar un error en el llenado de alguno de los tres TextField
        if sourceUnitTextField.text?.isEmpty == true {
            sourceUnitAsteriskLabel.isHidden = false
        } else {
            sourceUnitAsteriskLabel.isHidden = true
        }
        
        if targetUnitTextField.text?.isEmpty == true {
            targetUnitAsteriskLabel.isHidden = false
        } else {
            targetUnitAsteriskLabel.isHidden = true
        }
        
        if (Double(sourceAmountTextField.text!) != nil) {
            sourceAmountAsteriskLabel.isHidden = true
        }else {
            sourceAmountAsteriskLabel.isHidden = false
        }
    }
    
    //MARK: Solicitud a la API para convertir una cantidad de una unidad a otra
    func requestUnitChange(amount: Double){
        // declarar los valores necesarios de los valores necesarios para la solicitud de la API
        let name = nameIngredientLabel.text!.replacingOccurrences(of: " ", with: "_")
        let targetUnit = targetUnitTextField.text!.replacingOccurrences(of: " ", with: "_")
        let sourceUnit =  sourceUnitTextField.text!.replacingOccurrences(of: " ", with: "_")

        let conversionUnitsOfAnIngredient = ConversionUnitsOfAnIngredient(ingredientName: name, sourceAmount: amount, sourceUnit: sourceUnit, targetUnit: targetUnit)
        Task{
            do {
                let convertAmount = try await sendRequest(conversionUnitsOfAnIngredient) /***Realizamos una solicitud a la API con los valores establecidos*/
                answerLabel.text = convertAmount.answer /***La respuesta de la solicitud la insertamos al label de answer*/
            } catch {
                print(error)
                answerLabel.text = "Request another type of unit"
            }
        }
    }
}

//MARK: Extension para el protocolo de UISearchResultsUpdating
extension ConvertQuantitiesViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //verificamos si existe algun texto o si se esta modificado
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else {
            return
        }
        let ingredientSearchListToToolsPageViewController = searchController.searchResultsController as? IngredientSearchListToToolsPageViewController
        ingredientSearchListToToolsPageViewController?.delegate = self
        ingredientSearchListToToolsPageViewController?.lookForIngredients(word: searchString)/***Mandamos la palabra a la funcion para hacer la busqueda de los ingredientes y mostrarlos en la tableView*/
    }
}

//MARK: Extension para el delegado de IngredientSearchListToToolsPageViewController
extension ConvertQuantitiesViewController: IngredientSearchListToToolsPageViewControllerDelegate {
    func ingredientSearchListToToolsPageViewController(_ controller: IngredientSearchListToToolsPageViewController, possibleUnits: [String]?, name: String, image: String) {
        self.searchController.searchBar.resignFirstResponder()
        updateIngredient(name: name, image: image) /***Actualizamos la vista con la informacion de ingrediente seleccionado*/
        self.possibleUnits = possibleUnits! /***Actualizamos los nuevos valores del pickerView*/
        //El valor de las textfield y la respuesta las borramos
        sourceUnitTextField.text = ""
        targetUnitTextField.text = ""
        sourceAmountTextField.text = ""
        answerLabel.text = ""
    }
    
}


//MARK: Extension para la configuracion del PickerView
extension ConvertQuantitiesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK: Configuracion del pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return possibleUnits.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return possibleUnits[row]
    }
    
    //MARK: Seleccion de una fila del pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Verificar cual textField se esta editando para agregar el valor del pickerView en la textField editada
        if sourceUnitTextField.isEditing {
            sourceUnitTextField.text = possibleUnits[row]
            sourceUnitTextField.resignFirstResponder()
        } else {
            targetUnitTextField.text = possibleUnits[row]
            targetUnitTextField.resignFirstResponder()
        }
    }
}
