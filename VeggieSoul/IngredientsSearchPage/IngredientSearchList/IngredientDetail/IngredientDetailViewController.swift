//
//  IngredientDetailViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/09/23.
//
//MARK: INFO:
/*Vista para poder presentar la informacion de un ingrediente*/

import UIKit
import Charts

class IngredientDetailViewController: UIViewController {

    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var aisleLabel: UILabel!
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var unitLabel: UILabel!
    @IBOutlet var AddToFoodButton: UIButton!
    @IBOutlet var originalNameLabel: UILabel!
    @IBOutlet var consistencyLabel: UILabel!
    @IBOutlet var nutritionalInformationButton: UIButton!
    @IBOutlet var chartView: PieChartView!
    @IBOutlet var applyAmountButton: UIButton!
    
    
    //MARK: Inicializaciones generles
    var Id: Int! /***Valor que recibe de la vista anterior*/
    var name: String! /***Valor que recibe de la vista anterior*/
    var ingredient: IngredientID! /***Ingrediente con la informacion que se trabajara en esta vista*/
    var onePercent: Double = 0 /***Uno porciento del peso unitario del ingrediente*/
    var newAmount: Int = 0 /***Peso actual seleccionado del ingrediente*/
    var flag: Bool = true
    private let managerIngredient = CoreDataIngredient() /***Manager para CoreData*/
    var date: Date = Calendar.current.startOfDay(for: Date())
    
    
    //MARK: Configuraciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem() /***Configuramos el boton y el titulo de navigation item */
        //IngredientDetailSearch
        requestIngredient(amount: 1) /***Solicitamos informacion del ingrediente*/
        configureButtons () /***Configuramos el diseño de los botones*/
        amountTextField.keyboardType = .numberPad
        ingredientImageView.layer.cornerRadius = ingredientImageView.frame.width / 2
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Search", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Solicitamos informacion del ingrediente
    func requestIngredient(amount: Double) {
        let ingredientDetailSearch = IngredientDetailSearch(id: Id, amount: amount)
        Task{
            do {
                let ingredient = try await sendRequest(ingredientDetailSearch)/***Solicitamos el ingrediente a la API*/
                self.ingredient = ingredient
                updateIngredientDetail(ingredient: self.ingredient) /***Actualizamos la informacion obtenida del ingrediente y la presentamos en pantalla*/
                if flag {
                    /*Asignamos el valor de onePercent y este solo se podra establecer una vez sin importar si se llame nuevamente requestIngredient*/
                    onePercent = Double(ingredient.nutrition.weightPerServing.amount) / 100.0
                    flag = false
                }
                newAmount = ingredient.nutrition.weightPerServing.amount
            } catch{
                print(error)
            }
        }
    }
    
    
    //MARK: Actualizamos la vista con la informacion del ingrediente
    func updateIngredientDetail(ingredient: IngredientID) {
        nameLabel.text = self.name.capitalizingFirstLetter()
        aisleLabel.text = "Aisle: " + ingredient.aisle
        requestImageIngredient(imageURl: ingredient.image) /***Funcion para agregar la imagen del ingrediente*/
        amountTextField.text = String(ingredient.nutrition.weightPerServing.amount)
        unitLabel.text = ingredient.nutrition.weightPerServing.unit
        originalNameLabel.text = "Original Name: " + ingredient.originalName.capitalizingFirstLetter()
        consistencyLabel.text = "Consistency: " + ingredient.consistency.capitalizingFirstLetter()
        createPieChartView()/***Crear la vista de la grafica circular*/
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
    
    //MARK: Crear la vista donde estara la grafica circular
    func createPieChartView(){
        //Agregar titulo y descripcion al ChartView
        chartView.chartDescription.text = "Caloric Breakdown"
        chartView.centerText = "Caloric Breakdown"
        chartView.centerTextOffset.y = -125
        //Crear la Data de la ChartView con la informacion del ingrediente
        let percentProteinDataEntry = PieChartDataEntry(value: ingredient.nutrition.caloricBreakdown.percentProtein, label: "% Protein")
        let percentFatDataEntry = PieChartDataEntry(value: ingredient.nutrition.caloricBreakdown.percentFat, label: "% Fat")
        let percentCarbsDataEntry = PieChartDataEntry(value: ingredient.nutrition.caloricBreakdown.percentCarbs, label: "% Carbs")
        let numberOfDataEntry = [percentProteinDataEntry, percentCarbsDataEntry, percentFatDataEntry]
        //Crear el conjunto de datos con el arreglo anterior
        let chartDataSet = PieChartDataSet(entries: numberOfDataEntry, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        //Crear y asignar los colores a cada conjunto de datos
        let colors = [NSUIColor(cgColor: UIColor.purple.cgColor), NSUIColor(cgColor: UIColor.opaqueSeparator.cgColor),
                      NSUIColor(cgColor: UIColor.systemIndigo.cgColor)]
        chartDataSet.colors = colors
        chartView.data = chartData/***Asignar la Data creada a la ChartView*/
    }
    
    //MARK: Configuramos el diseño de tres botones
    func configureButtons () {
        //Realizamos un redondeo al boton de agregar a la comida
        AddToFoodButton.layer.cornerRadius = AddToFoodButton.frame.height / 3
        //Realizamos  un redondeo al boton de mostrar informacion nutricional y le agreamos un borde de color
        nutritionalInformationButton.layer.cornerRadius = nutritionalInformationButton.frame.height / 4
        let borderColor = UIColor(named: "Opaque Separator Color")
        nutritionalInformationButton.layer.borderColor = borderColor?.cgColor
        nutritionalInformationButton.layer.borderWidth = 1
        //Realizamos  un redondeo al boton de actualizar la nueva cantidad del ingrediente
        applyAmountButton.layer.cornerRadius = applyAmountButton.frame.height / 4
        applyAmountButton.layer.borderColor = borderColor?.cgColor
        applyAmountButton.layer.borderWidth = 1
    }
    
    //MARK: Ir a la vista de detalle de la informacion nutrimental del ingrediente
    @IBAction func SeeNutritionalInformation(_ sender: Any) {
        // instanciamos una vista para presentarla
        let ingredientNutritionalInformationStoryboard = UIStoryboard(name: "IngredientNutritionalInformation", bundle: .main)
        //Instanciamos un ingredientNutritionalInformationViewController
        if let ingredientNutritionalInformationViewController = ingredientNutritionalInformationStoryboard.instantiateViewController(withIdentifier: "IngredientNutritionalInformationVC") as? IngredientNutritionalInformationViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            ingredientNutritionalInformationViewController.ingredientNutrients = ingredient.nutrition.nutrients/***Pasamos la informacion nutrimental del ingrediente*/
            navigationController?.pushViewController(ingredientNutritionalInformationViewController, animated: true)
        }
    }
    
    //MARK: Agregar el ingrediente a CoreData
    @IBAction func ButtonAddToFood(_ sender: UIButton) {
        buttonAnimation(button: sender)/***Animamos el boton*/
        amountTextField.resignFirstResponder() /***Quitamos el teclado*/
        amountTextField.text = String(newAmount)
        CoreDataIngredient.shared.newIngredients.append(ingredient) /***Agregar el ingrediente a CoreData*/
        managerIngredient.saveIngredient(ingredient: ingredient, date: date)
    }
    
    
    @IBAction func ButtonApplyAmount(_ sender: UIButton) {
        /*Realiza una nueva solicitud a la API con los nuevos valores de peso requerido*/
        buttonAnimation(button: sender)/***Animamos el boton*/
        amountTextField.resignFirstResponder()
        /*Solo se podra realizar esta solicitud si se cumple con lo siguiente:*/
        guard let amount = amountTextField.text, Double(amount) != Double(newAmount) else {return}
        /*Calculamos el nuevo peso agregado para realizar la solicitud*/
        let DoubleAmount = Double(amount)! / self.onePercent
        let percentAmount = DoubleAmount * 0.01
        newAmount = Int(amount)!
        requestIngredient(amount: percentAmount)/***Realizamos la nueva  solicitud a la API con el nuevo peso*/
    }
    
    
    @IBAction func quantityChangeInTextField(_ sender: UITextField) {
        /*En caso de que el textField este vacio no se podra aplicar la nueva solicitud de red o no se podra agregar el ingredinete a la comida por medio de inabilitar dos botones*/
        guard let text = sender.text, text != "" else {
            applyAmountButton.isEnabled = false
            AddToFoodButton.isEnabled = false
            return
        }
        applyAmountButton.isEnabled = true
        AddToFoodButton.isEnabled = true
    }
    
    
    //MARK: Realiza una animacion a un boton
    func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            button.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) /***Escala el boton un poco mas grande*/
        }) {(_) in
            UIView.animate(withDuration: 0.25, animations: {
                button.transform = CGAffineTransform.identity /***Despues de un tiempo regresa el boton a su estado original*/
            })
        }
    }
    
}
