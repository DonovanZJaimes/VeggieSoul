//
//  IngredientNutritionalInformationViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 20/09/23.
//
//MARK: INFO:
/*Vista para poder presentar la informacion nutrimental de un ingrediente*/

import UIKit
import Charts

class IngredientNutritionalInformationViewController: UIViewController {

    @IBOutlet var ChartView: HorizontalBarChartView!
    
    //MARK: Inicializaciones generles
    var ingredientNutrients: [IngredientNutrients]! /***Valores que recibe de la vista anterior IngredientDetail*/
    var macronutrients = [IngredientNutrients]()
    var micronutrients = [IngredientNutrients]()
    var limitTheseNutrients = ["Calories", "Fat", "Trans Fat", "Saturated Fat", "Mono Unsaturated Fat", "Poly Unsaturated Fat", "Alcohol", "Net Carbohydrates", "Carbohydrates", "Sugar", "Cholesterol", "Sodium", "Caffein"]
    
    
    //MARK: Configuraciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem ()/***Configuramos el boton y titulo del navigationItem*/
        separateBetweenMacroAndMicronutrients()/***Separar los nutrientes del ingrediente*/
        updateChart(nutrients: macronutrients)/***Configurar la ChartView con los macronutrientes*/

    }
    
    //MARK: Separar los nutrientes del ingrediente
    func separateBetweenMacroAndMicronutrients() {
        for index in 0 ..< ingredientNutrients.count {
            if ingredientNutrients[index].unit == "g" || ingredientNutrients[index].unit == "kcal" {
                macronutrients.append(ingredientNutrients[index])/***Se agregan los macronutrientes*/
            } else {
                micronutrients.append(ingredientNutrients[index])/***Se agregan los micronutrientes*/
            }
        }
    }
    
    //MARK: Crear y actualizar la ChartView
    private func updateChart(nutrients: [IngredientNutrients]){
        // Creación de los dos tipos de entradas para la BarChart
        let (entriesBadNutrients, entriesGoodNutrients) = entriesBadAndGoodNutrients(nutrients: nutrients) /***Inicializacion de los arreglos de los nutrientes buenos y malos*/

        // Configurar el eje x de la BarChart
        let xAxis = ChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawAxisLineEnabled = true
        xAxis.drawGridLinesEnabled = false
        xAxis.granularityEnabled = false
        xAxis.setLabelCount(nutrients.count, force: false)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: nutrients.map {$0.name + "  \($0.amount)  " + $0.unit}) /***Se ingresa el nombre, cantidad y unidad de cada ingrediente al label del eje x de la BarChart*/
        xAxis.axisMaximum = Double(nutrients.count)
        
        // Se inicializan las dos entradas para los dos tipos de nutrientes con su respectiva informacion
        let set1 = BarChartDataSet(entries: entriesBadNutrients, label: "limit These")
        let set2 = BarChartDataSet(entries: entriesGoodNutrients, label: "Get Enough Of These")
        
        //Configuramos el color de cada entrada para diferenciar
        set1.setColor(NSUIColor(cgColor: UIColor.systemTeal.cgColor))
        set2.setColor(NSUIColor(cgColor: UIColor.opaqueSeparator.cgColor))
        
        //Agregamos la Data al BarChart
        let data = BarChartData(dataSets: [set2, set1])
        ChartView.data = data
    
    }
    
    
    
    //MARK: Regreso de arreglos de nutrientes buenos y malos
    /*Funcion que regresa dos arreglos de nutrintes, uno con nutrientes buenos para la salud y otro no*/
    func entriesBadAndGoodNutrients(nutrients: [IngredientNutrients]) -> ([BarChartDataEntry],[BarChartDataEntry]) {
        
        var entriesBadNutrients = [BarChartDataEntry]()/***Arreglo de los nutrientes malos*/
        var entriesGoodNutrients = [BarChartDataEntry]() /***Arreglo de los nutrientes buenos*/
        for index in 0 ..< nutrients.count {
            for index2 in 0 ..< limitTheseNutrients.count {
                if nutrients[index].name.contains(limitTheseNutrients[index2]) {
                    /*En caso de que los nutrientes esten en la lista de limitTheseNutrients:*/
                    entriesBadNutrients.append(BarChartDataEntry(x: Double(index), y: nutrients[index].percentOfDailyNeeds ?? 0.0)) /***Se agregan los malos nutrientes */
                } else {
                    entriesGoodNutrients.append(BarChartDataEntry(x: Double(index), y: nutrients[index].percentOfDailyNeeds ?? 0.0)) /***Se agregan los buenos nutrientes */
                }
            }
        }
        return (entriesBadNutrients, entriesGoodNutrients) /***Regreso de los dos arreglos*/
    }
    
    //MARK: Cambiar de vista entre micronutrientes y macronutrientes
    @IBAction func switchBetweenMacroAndMicronutrients(_ sender: UISegmentedControl) {
        guard 0 == sender.selectedSegmentIndex else {
            updateChart(nutrients: micronutrients) /***Actualiza la vista para los micronutrientes*/
            return
        }
        updateChart(nutrients: macronutrients) /***Actualiza la vista para los macronutrientes*/
        
        
    }
    
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Nutritional Information"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Ingredient", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }

}
