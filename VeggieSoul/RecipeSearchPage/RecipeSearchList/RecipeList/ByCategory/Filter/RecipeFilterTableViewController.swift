//
//  RecipeFilterTableViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 09/09/23.
//
//MARK: INFO:
/*Vista complementaria para poder presentar las opciones de filtrado para la vista de  RecipeListByCategoryViewController */

import UIKit


class RecipeFilterTableViewController: UITableViewController {

    //MARK: definir Outlets del Storyboard
    @IBOutlet var dietLabel: UILabel!
    @IBOutlet var dietsPickerView: UIPickerView!
    @IBOutlet var mainCourseSwitch: UISwitch!
    @IBOutlet var saladSwitch: UISwitch!
    @IBOutlet var beverageSwitch: UISwitch!
    @IBOutlet var breakfastSwitch: UISwitch!
    @IBOutlet var soupSwitch: UISwitch!
    @IBOutlet var appetizerSwitch: UISwitch!
    @IBOutlet var dessertSwitch: UISwitch!
    
    
    //MARK: Inicializaciones generales
    let Diets = ["Vegetarian", "Lacto-Vegetarian", "Ovo-Vegetarian", "Vegan"] /***Valores para el pickerView*/
    let Meals = ["ourse", "alads", "everage", "reakfast", "oup", "ppetizer", "essert"] /***Tipo de comidas disponibles*/
    let dietIndexPath = IndexPath(row: 0, section: 0)
    let dietPickerViewIndexPath = IndexPath(row: 1, section: 0)
    var isPickerViewHidden: Bool = true
    var oldTitle: String = ""
    var mealRows = [Int]() /***Index para el tipo de comidas selecionadas*/
    var dietType: String = ""
    var typeOfMealsSelected = [String]()
    var typeOfDietSelected: String = ""
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        //asignar el delegado y dataSource para el pickerView
        dietsPickerView.delegate = self
        dietsPickerView.dataSource = self
        /*Asignar el tipo de comidas a tres variables*/
        //oldTitle = VariablesFilterRecipes.shared.typeOfMealToFilterRecipes
        typeOfMealsSelected = VariablesFilterRecipes.shared.typeOfMealsSelected
        VariablesFilterRecipes.shared.typeOfMealToFilterRecipes += typeOfMealsSelected.joined(separator: " ")
        configureSwitchs() /***Configura el estado de los switchs dependiendo de las asignaciones anteriores*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSwitchs()
    }
    
    //MARK: Configura el estado de los switchs
    func configureSwitchs() {
        
        oldTitle = VariablesFilterRecipes.shared.typeOfMealToFilterRecipes
        var mealToDisable: Int = 0 /***index para desabilitar un switch*/
        for index in 0 ..< Meals.count {
            if VariablesFilterRecipes.shared.typeOfMealToFilterRecipes.contains(Meals[index]){
                mealRows.append(index) /***Agregamos index para activar los switchs respectivamente al tipo de comidas que se seleccionaron*/
                if oldTitle.contains(Meals[index]) {
                    mealToDisable = index /***Asignar el index para desabilitar un switch */
                }
            }
        }
        //configura los switchs respectivamente a las comidas selecionadas
        for index in 0 ..< mealRows.count {
            switch mealRows[index] {
            case 0:
                mainCourseSwitch.isOn = true
                mainCourseSwitch.isEnabled = mealToDisable == 0 ? false : true
            case 1:
                saladSwitch.isOn = true
                saladSwitch.isEnabled = mealToDisable == 1 ? false : true
            case 2:
                beverageSwitch.isOn = true
                beverageSwitch.isEnabled = mealToDisable == 2 ? false : true
            case 3:
                breakfastSwitch.isOn = true
                breakfastSwitch.isEnabled = mealToDisable == 3 ? false : true
            case 4:
                soupSwitch.isOn = true
                soupSwitch.isEnabled = mealToDisable == 4 ? false : true
            case 5:
                appetizerSwitch.isOn = true
                appetizerSwitch.isEnabled = mealToDisable == 5 ? false : true
            case 6:
                dessertSwitch.isOn = true
                dessertSwitch.isEnabled = mealToDisable == 6 ? false : true
            default:
                print("nil")
            }
        }
    }
    
    //MARK: Cambiar el valor de un switch
    @IBAction func ChangeTypeOfMeal(_ sender: UISwitch) {
        /*Cada vez que se modifica un switch se acualiza la lista del tipo de comida en  typeOfMealsSelected*/
        typeOfMealsSelected.removeAll()
        if mainCourseSwitch.isOn {
            typeOfMealsSelected.append("main_course")
        }
        if saladSwitch.isOn {
            typeOfMealsSelected.append("salads")
        }
        if beverageSwitch.isOn {
            typeOfMealsSelected.append("beverage")
        }
        if breakfastSwitch.isOn {
            typeOfMealsSelected.append("breakfast")
        }
        if soupSwitch.isOn {
            typeOfMealsSelected.append("soup")
        }
        if appetizerSwitch.isOn {
            typeOfMealsSelected.append("appetizer")
        }
        if dessertSwitch.isOn {
            typeOfMealsSelected.append("dessert")
        }
        /*Con la lista actualizada se pasan a las variables de la clase VariablesFilterRecipes*/
        VariablesFilterRecipes.shared.typeOfMealsSelected = typeOfMealsSelected
        VariablesFilterRecipes.shared.typeOfMealToFilterRecipes = typeOfMealsSelected.joined(separator: " ")
    }
    
    
    //MARK: Configuracion de la primera seccion de la tableView
    /*Configurar la altura de la row del pickerview*/
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dietPickerViewIndexPath where isPickerViewHidden == true:
            return  0 /***En caso de que isPickerViewHidden  sea true, la altura de la celda sera cero*/
        default:
            return UITableView.automaticDimension
        }
    }
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case dietPickerViewIndexPath:
            return 200 /***El tamaño nominal del la celda del pickerView sera de 200*/
        default:
            return UITableView.automaticDimension
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /*Cuando se presione la fila 0 y seccion 0 cambiara la altura de l celda del pickerView*/
        if dietIndexPath == indexPath {
            isPickerViewHidden.toggle()
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
}


//MARK: Configuracion del PickerView
extension RecipeFilterTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        Diets.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        Diets[row] /***Nombre de los titulos */
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //Cada vez que seleccione un nuevo valor del pickerView
        dietLabel.text = Diets[row]
        isPickerViewHidden.toggle()
        typeOfDietSelected = Diets[row].lowercased().replacingOccurrences(of: "-", with: "_")
        VariablesFilterRecipes.shared.typeOfDietSelected = typeOfDietSelected
        //Modificar la altura de la celda del pickerView
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    

}
