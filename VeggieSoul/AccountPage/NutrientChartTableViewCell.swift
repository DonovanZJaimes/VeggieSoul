//
//  NutrientChartTableViewCell.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 31/10/23.
//
//MARK: INFO:
/*Muestra el progreso nutrimental diario con la posibilidad de modificar el usuario y ver la informacion nutrimental mas detallada*/

import UIKit
import Charts
import CoreData
//MARK: Creacion del delegado para los botones de la celda
protocol NutrientChartTableViewCellDelegate: AnyObject {
    //Metodo que enviara esta celda para obtener su informacion
    func nutrientChartTableViewCell(tableViewCell: NutrientChartTableViewCell )
    //Metodo que enviara esta celda para obtener su informacion de calorias
    func nutrientChartTableViewCellToCalories(tableViewCell: NutrientChartTableViewCell )
}

class NutrientChartTableViewCell: UITableViewCell {

    
    @IBOutlet var kcalPieChart: PieChartView!
    @IBOutlet var amountCarbsLabel: UILabel!
    @IBOutlet var amountProteinsLabel: UILabel!
    @IBOutlet var nutritionalInformationButton: UIButton!
    @IBOutlet var amountFatLabel: UILabel!
    @IBOutlet var carbsProgressView: UIProgressView!
    @IBOutlet var proteinProgressView: UIProgressView!
    @IBOutlet var fatProgressView: UIProgressView!
    
    
    private let managerUser = CoreDataUsers() /***Manager para CoreData*/
    //valores para la chart view y los progres view
    var kcalTotal: Double = 2000
    var carbsTotal = 250
    var proteinTotal = 190
    var fatTotal = 85
    weak var delegate: NutrientChartTableViewCellDelegate? /***Creamos el delegado*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButton()
        updateNutrients()
    }
    
    //Configuramos el boton
    func setUpButton() {
        nutritionalInformationButton.layer.cornerRadius = nutritionalInformationButton.frame.height / 3
    }
    
    //Actualizamos los valores nutrimentales principales del usuario
    func updateNutrients () {
        let users = managerUser.fetchUsers()
        kcalTotal = users.last!.calories
        carbsTotal = Int(users.last!.carbohydrates)
        proteinTotal = Int(users.last!.proteins)
        fatTotal = Int(users.last!.fats)
    }
    
    //MARK: Acciones de los botones
    @IBAction func goToNutritionalInformation(_ sender: UIButton) {
        delegate?.nutrientChartTableViewCell(tableViewCell: self) /***Empezamos el delegado cuando se presione el boton y enviamos la celda selecionada , este delegado lo realizara la vista "AccountPage"*/
    }
    
    @IBAction func goToUpdateCalories(_ sender: UIButton) {
        delegate?.nutrientChartTableViewCellToCalories(tableViewCell: self) /***Empezamos el delegado cuando se presione el boton y enviamos la celda selecionada , este delegado lo realizara la vista "AccountPage"*/
    }
    
    
    // Configura los label de la celda
    func updateAmounts(carbs: Int, protein: Int, fat: Int){
        amountCarbsLabel.text = "\(carbs)/\(carbsTotal) gr"
        amountProteinsLabel.text = "\(protein)/\(proteinTotal) gr"
        amountFatLabel.text = "\(fat)/\(fatTotal) gr"
    }
    // configura los progres View
    func updateProgresViews (carbs: Int, protein: Int, fat: Int) {
        carbsProgressView.progress = Float(( 1.0 / Double(carbsTotal) ) * Double(carbs))
        proteinProgressView.progress = Float((1.0 / Double(proteinTotal)) * Double(protein))
        fatProgressView.progress = Float((1.0 / Double(fatTotal)) * Double(fat))
    }
    
    
    //MARK: Crear la vista donde estara la grafica circular
    func createPieChartView(kcalConsumed: Double ){
        //Agregar titulo y descripcion al ChartView
        kcalPieChart.chartDescription.text = "Nutritional Information"
        kcalPieChart.centerText = "\(Int(kcalConsumed))/\(Int(kcalTotal)) Kcal"
        kcalPieChart.centerTextOffset.y = -125
        kcalPieChart.holeColor = NSUIColor(cgColor: UIColor.clear.cgColor)
        //Crear la Data de la PieChartView con la informacion del ingrediente
        let percentProteinDataEntry = PieChartDataEntry(value: kcalConsumed, label: "kcal Consumed")
        let valueRemaining = kcalConsumed > kcalTotal ? 0 : (kcalTotal - kcalConsumed)
        var percentFatDataEntry = PieChartDataEntry(value: valueRemaining, label: "kcal Remaining")
        let numberOfDataEntry = [percentProteinDataEntry, percentFatDataEntry]
        //Crear el conjunto de datos con el arreglo anterior
        let chartDataSet = PieChartDataSet(entries: numberOfDataEntry, label: "")
        chartDataSet.entryLabelColor = NSUIColor(cgColor: UIColor.label.cgColor)
        chartDataSet.valueTextColor = NSUIColor(cgColor: UIColor.label.cgColor)
        let chartData = PieChartData(dataSet: chartDataSet)
        //Crear y asignar los colores a cada conjunto de datos
        let colors = [NSUIColor(cgColor: UIColor(named: "ColorTeal")!.cgColor), NSUIColor(cgColor: UIColor.darkGray.cgColor)]
        chartDataSet.colors = colors
        kcalPieChart.data = chartData/***Asignar la Data creada a la ChartView*/
    }
    
    
}
