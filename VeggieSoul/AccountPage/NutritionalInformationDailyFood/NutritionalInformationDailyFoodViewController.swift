//
//  NutritionalInformationDailyFoodViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 05/11/23.
//
//MARK: INFO:
/*Vista para poder presentar toda la informacion nutrimental que se consuio en el dia, por recetas o ingredientes*/

import UIKit
import Charts

class NutritionalInformationDailyFoodViewController: UIViewController {

    //MARK: definir Outlets del Storyboard
    @IBOutlet var ChartView: HorizontalBarChartView!
    
    //MARK: Inicializaciones generles
    var nutritionalInformationMeals: [DailyNutritionalInformation]! /***Informacion nutrimental que recibe de la anterior vista*/
    var macronutrients = [DailyNutritionalInformation]()
    var micronutrients = [DailyNutritionalInformation]()
    let limitTheseNutrients = ["Calories", "Fat", "Trans Fat", "Saturated Fat", "Mono Unsaturated Fat", "Poly Unsaturated Fat", "Alcohol", "Net Carbohydrates", "Carbohydrates", "Sugar", "Cholesterol", "Sodium", "Caffein"] /***Nutrientes dañinos*/
    

    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        sumNutrientsMeals() /***Separar los nutrientes de las comidas*/
        configureNavigationItem ()/***Configuramos el boton y titulo del navigationItem*/
        updateChart(nutrients: macronutrients)/***Configurar la ChartView con los macronutrientes*/
    }
    
    // MARK: Separar los nutrientes de las comidas
    func sumNutrientsMeals(){
        //separar los macronutrientes de la informacion nutrimental general
        macronutrients = NutritionalInformationDailyMacronutrients
        for nutrient in 0 ..< macronutrients.count {
            for index1 in 0 ..< nutritionalInformationMeals.count {
                if macronutrients[nutrient].name == nutritionalInformationMeals[index1].name {
                    macronutrients[nutrient].amount += nutritionalInformationMeals[index1].amount
                    macronutrients[nutrient].percentOfDailyNeeds! += nutritionalInformationMeals[index1].percentOfDailyNeeds!
                }
            }
        }
        //separar los micronutrientes de la informacion nutrimental general
        micronutrients = NutritionalInformationDailyMicronutrients
        for nutrient in 0 ..< micronutrients.count {
            for index1 in 0 ..< nutritionalInformationMeals.count {
                if micronutrients[nutrient].name == nutritionalInformationMeals[index1].name {
                    micronutrients[nutrient].amount += nutritionalInformationMeals[index1].amount
                    micronutrients[nutrient].percentOfDailyNeeds! += nutritionalInformationMeals[index1].percentOfDailyNeeds!
                }
            }
        }
    }
    
    
    //MARK: Crear y actualizar la ChartView
    private func updateChart(nutrients: [DailyNutritionalInformation]){
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
    /*metodo que regresa dos arreglos de nutrintes, uno con nutrientes buenos para la salud y otro no*/
    func entriesBadAndGoodNutrients(nutrients: [DailyNutritionalInformation]) -> ([BarChartDataEntry],[BarChartDataEntry]) {
        
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
    // metodo que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Nutritional Information"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Daily Food", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
}
