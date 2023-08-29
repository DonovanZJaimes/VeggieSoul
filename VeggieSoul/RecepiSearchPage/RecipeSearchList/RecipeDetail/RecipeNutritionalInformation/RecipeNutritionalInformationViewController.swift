//
//  RecipeNutritionalInformationViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 04/08/23.
//
//MARK: INFO:
/*Vista que nos ayudara a mostrar la informacion detallada de la informacion nutricinal de la receta sleccionada */

import UIKit
import Charts

class RecipeNutritionalInformationViewController: UIViewController {
    
    // MARK: Outlets de la vista
    @IBOutlet var CaloriesLabel: UILabel!
    @IBOutlet var ProteinLabel: UILabel!
    @IBOutlet var TotalFatLabel: UILabel!
    @IBOutlet var CarbsLabel: UILabel!
    @IBOutlet var ChartView: BarChartView! /***Outlet de la vista encargada de mostrar la informacion de una grafica de barras*/
    
    
    //MARK: Inicializaciones generles
    var recipeNutrition: RecipeNutrition! /***Informacion recibida de la vista RecipeDetailViewController*/
    var nutrients: [Flavonoid]!/***Data para la CharView*/

    
    //MARK: Actualizacion y configuracion de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataOfChartView() /***Configuramos la data para la CharView*/
        createChart() /***Creamos y configuramos la ChartView***/
        setLabels() /***Configuramos los valores de las 4 labels de la vista*/
        configureNavigationItem () /***Configura el titulo y botones de navigation item*/
        
    }
    
    //MARK: Configurar la Data para el ChartView
    func configureDataOfChartView() {
        nutrients = recipeNutrition.nutrients/***Configuramos los valores de nutriets para la ser la Data */
        nutrients.reverse()
    }
    
    //MARK: Crear y configurar la ChartView
    private func createChart(){
        // Creación de los dos tipos de entradas para la BarChart
        
        let borderlineBadNutrientIndex = nutrientSeparationBoundary()/***Encontrar el limite de los nutrientes buenos y malos para la salud*/
        
        var (entriesBadNutrients, entriesGoodNutrients) = entriesBadAndGoodNutrients(borderlineIndex: borderlineBadNutrientIndex) /***Inicializacion de los arreglos de los nutrientes buenos y malos*/
        
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
        let set1 = BarChartDataSet(entries: entriesBadNutrients, label: "Get Enough Of These")
        let set2 = BarChartDataSet(entries: entriesGoodNutrients, label: "limit These")
        
        //Configuramos el color de cada entrada para diferenciar
        set2.setColor(NSUIColor(cgColor: UIColor(named: "ColorTeal")!.cgColor))
        set1.setColor(NSUIColor(cgColor: UIColor.opaqueSeparator.cgColor))
        
        //Agregamos la Data al BarChart
        let data = BarChartData(dataSets: [set2, set1])
        ChartView.data = data
    
    }
    
    //MARK: Regreso de arreglos de nutrientes buenos y malos
    /*Funcion que regresa dos arreglos de nutrintes, uno con nutrientes buenos para la salud y otro no*/
    func entriesBadAndGoodNutrients(borderlineIndex: Int) -> ([BarChartDataEntry],[BarChartDataEntry]) {
        
        //Arreglo de los nutrientes malos
        var entriesBadNutrients = [BarChartDataEntry]()
        for x in 0..<borderlineIndex {
            entriesBadNutrients.append(
                BarChartDataEntry(x: Double(x), y: nutrients[x].percentOfDailyNeeds ?? 0.0 )
            )
        }
        
        //Arreglo de los nutrinetes buenos
        var entriesGoodNutrients = [BarChartDataEntry]()
        for x in borderlineIndex..<nutrients.count {
            entriesGoodNutrients.append(
                BarChartDataEntry(x: Double(x), y: nutrients[x].percentOfDailyNeeds ?? 0.0 )
            )
        }
        
        return (entriesBadNutrients, entriesGoodNutrients) /***Regreso de los dos arreglos*/
    }
    
    //MARK: Indice de separacion de nutrientes buenos y malos
    func nutrientSeparationBoundary() -> Int {
        /***En la solicitud de la API para los nutrientes se envia un arreglo ordenado donde apartir de la proteina son nutrientes buenos y antes de esta son malos, pero no siempre envia el valor de la proteina, entonces se determina el indice limite de los bunos y malos*/
        var indexProtein = 0
        var indexAlcohol = 0
        var indexSodium =  0
        for x in 0..<nutrients.count {
            if nutrients[x].name == "Protein" {
                indexProtein = x
                continue
            }
            if nutrients[x].name == "Alcohol" {
                indexAlcohol = x
                continue
            }
            if nutrients[x].name == "Sodium" {
                indexSodium = x
                continue
            }
        }
        let limitIndex = max(indexSodium, indexAlcohol, indexProtein)
        return limitIndex
    }
    
    //MARK: Configurar los valores de las labels dde la vista
    func setLabels () {
        /*Presentar el valor nutricional de las 4 principales nutrientes en cada label correspondiente*/
        recipeNutrition.nutrients.forEach { nutrient in
            if nutrient.name == "Calories" {
                CaloriesLabel.text = "\(nutrient.amount) Calories"
            }
            if nutrient.name == "Fat" {
                TotalFatLabel.text = "\(nutrient.amount)\(nutrient.unit) Total Fat"
            }
            if nutrient.name == "Carbohydrates" {
                CarbsLabel.text = "\(nutrient.amount)\(nutrient.unit) Carbs"
            }
            if nutrient.name == "Protein" {
                ProteinLabel.text = "\(nutrient.amount)\(nutrient.unit) Protein"
            }
        }
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
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Recipe", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
  

}

