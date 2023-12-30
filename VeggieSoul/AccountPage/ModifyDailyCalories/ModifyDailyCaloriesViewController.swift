//
//  ModifyDailyCaloriesViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 12/12/23.
//
//MARK: INFO:
/*Vista para poder presentar y modificar la informacion del usurio en base a sus necesidades nutrimentales*/

import UIKit
import CoreData

class ModifyDailyCaloriesViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var heightTableView: NSLayoutConstraint!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var genderSegmented: UISegmentedControl!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var heightSlider: UISlider!
    @IBOutlet var yearsTextField: UITextField!
    @IBOutlet var weightTextField: UITextField!
    var pickerView = UIPickerView() /***Picker view para mostrar las edades y estaturas*/
    
    //MARK: Inicializaciones generles
    let titles = ["Activity", "Goal", "Distribution"]/***Titulos de las secciones de la table View*/
    var user2: UserEntity!
    let genders = ["Man", "Women"]
    var selectedQuestions = [0, 0, 0] /***Valores de las filas seleccionas de las 3 secciones de la tableView*/
    private let managerUser = CoreDataUsers() /***Manager para CoreData*/
    
    //Data para picker View
    var line1PV: [String] = []
    var line2PV: [String] = []
    let line3PV = ["", ".1", ".2", ".3", ".4", ".5", ".6", ".7", ".8", ".9"]
    var age: Int = 0
    var weight: Double = 0
    var weightPart1 = 0
    var weightPart2 = ""
    var height = 0
     
    // Definir que text field se activara
    enum TextFields: Hashable {
        case age
        case weight
    }
    var textFieldActive = TextFields.weight
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewData()/***Configuramos los datos del usuario en la vista*/
        setUpTableView() /**Configuramos el delegado, data source y la celda*/
        setUpTitle ()/***Configuramos el titulo del navigationItem*/
        setUpPossibleAgesAndWeights() /***establecemos el rango de valores de edades y pesos disponibles*/
        setUpPickerView() /***asignar el delegado y dataSource para el pickerView*/
        setUpAgeTextField() /***Asignamos el tipo de entrada y texto*/
        setUpWeightTextField() /***Asignamos el tipo de entrada y texto*/
        enableDataUpdateButton() /***Habilitar el boton en caso de cambios en las entradas*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize"
        {
            if object is UITableView
            {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    self.heightTableView.constant = newSize.height
                }
            }
        }
    }
    
    //MARK: Configurar el tableView
    func setUpTableView() {
        //Configuramos el responsable del delagado y dataSource
        tableView.dataSource = self
        tableView.delegate = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "OptionCalculateCaloriesTableViewCell", bundle: .main), forCellReuseIdentifier: "OptionCalculateCaloriesTVC")
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        navigationItem.title = "Data Update"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        //self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
        
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Update", style: .done, target: self, action: #selector(updateCalories))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "ColorTeal")!
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Daily Food", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Actualizar las nuevas calorias diarias
    //Presentamos una alerta con la nueva informacion nutrimental
    @objc func updateCalories(){
        //obtenemos las nuevas Calorias y porciones de los macronutrientes
        let kCal = calculateDailyCalories()
        let macronutrients = distributeMacronutrients(kCal: Double(kCal))
        //Creamos una alerta con la informacion anterior
        let message = "For a daily caloric intake of \(kCal) kcal: \n Carbohydrates: \(macronutrients[0])g \n Proteins: \(macronutrients[1])g \n Fats: \(macronutrients[2])g"
        let alertController = UIAlertController(title: "Your new calories are: \(kCal) kCal", message: message, preferredStyle: .alert)
        //Se crea dos acciones para la alerta y la presentamos
        let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertAction2 = UIAlertAction(title: "Accept", style: .default, handler: { action in
            //Se actualiza los nuevos valores del usuario en CoreData
            self.updateUser(kCal: Double(kCal), macronutrients: macronutrients)
        })
        alertController.addAction(alertAction)
        alertController.addAction(alertAction2)
        alertController.popoverPresentationController?.sourceView = navigationItem.rightBarButtonItem?.customView
        present(alertController, animated: true, completion: nil)
    }
    
    //Calculamos las nuevas calorias del dia
    func calculateDailyCalories() -> Int {
        var kCal: Double = 0
        //Dependoendo si el usuario es hombre o mujer las calorias totales seran difenetes
        switch genders[genderSegmented.selectedSegmentIndex] {
        case "Man":
            kCal = 88.362 + (13.397 * weight) + (4.799 * Double(height)) - (5.677 * Double(age))
        default: //Women
            kCal = 447.593 + (9.247 * weight) + (3.098 * Double(height)) - (4.33 * Double(age))
        }
        //Dependiendo cual es el nivel de actividad dl usuario
        switch selectedQuestions[0] {
        case 0:
            kCal *= 1.2
        case 1:
            kCal *= 1.375
        case 2:
            kCal *= 1.55
        case 3:
            kCal *= 1.725
        default:
            kCal *= 1.9
        }
        //Dependiendo cual es la meta del usuario
        switch selectedQuestions[1] {
        case 0:
            kCal *= 0.85
        case 1:
            kCal *= 1.075
        default:
            kCal *= 1
        }
        
        return Int(kCal)
    }
    
    //Distribucion de los macronutrientes
    func distributeMacronutrients(kCal: Double) -> [Int] {
        //Dependiendo del objetivo de usuario se regresara una cantidad especifica de gr para los macronutrientes
        var macronutrients: [Int] = [0, 0, 0] // Carbohidratos, Proteínas, Grasas
        let distribution = [[0.4, 0.3, 0.3], [0.3, 0.4, 0.3], [0.2, 0.4, 0.4], [0.5, 0.25, 0.25], [0.1, 0.2, 0.7]] /*** Distribucion de macronutrientes dependiendo de la seleccion del usuario*/
        macronutrients[0] = Int((kCal * distribution[selectedQuestions[2]][0]) / 4)
        macronutrients[1] = Int((kCal * distribution[selectedQuestions[2]][1]) / 4)
        macronutrients[2] = Int((kCal * distribution[selectedQuestions[2]][2]) / 9)
        
        return macronutrients
    }
    //Actualizar los nuevos valores del ususrio en CoreData
    func updateUser(kCal: Double, macronutrients: [Int]){
        //Creamos el usuario con las  nuevas especificaciones
        let userVeggieSoul = UserVS(activity: Int64(selectedQuestions[0]), age: Int64(age), distribution: Int64(selectedQuestions[2]), gender: genders[genderSegmented.selectedSegmentIndex], goal: Int64(selectedQuestions[1]), height: Int64(height), name: "userVeggieSoul", weight: weight, kCalories: kCal, carbohydrates: Double(macronutrients[0]), fats: Double(macronutrients[2]), proteins: Double(macronutrients[1]))
        //Actalizamos el ususrio en CoreData
        managerUser.modifyUser(withUID: user2.uID!, newInformation: userVeggieSoul)
        //let users = managerUser.fetchUsers()
        //user2 = users.last
        enableDataUpdateButton() /***Habilitar el boton en caso de cambios en las entradas*/
    }
    
    //MARK: Configurar la picker view
    func setUpPickerView() {
        //asignar el delegado y dataSource para el pickerView
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    //Configuramos los valores de la PickerView
    func setUpPossibleAgesAndWeights(){
        for age in 9 ... 99 {
            line1PV.append(String(age))
        }
        for weight in 10 ... 150 {
            line2PV.append(String(weight))
        }
    }
    
    //MARK: Configurar los TextField
    //textField de la edad
    func setUpAgeTextField() {
        //Asignamos el tipo de entrada y texto
        age = Int(user2.age)
        yearsTextField.inputView = pickerView
        yearsTextField.text = String(age)
    }
   
    //textField del peso
    func setUpWeightTextField() {
        //Asignamos el tipo de entrada y texto
        weight = user2.weight
        weightPart1 = Int(user2.weight)
        weightPart2 = String(Double(Int(user2.weight)) - user2.weight)
        weightTextField.inputView = pickerView
        weightTextField.text = String(weight)
    }
    
    //MARK: Configurar la vista
    func setUpViewData() {
        //configuramos el valor de altura
        heightLabel.text = "\(user2.height) cm"
        heightSlider.value = Float(user2.height)
        height = Int(user2.height)
        //configuramos el valor de genero del usuario
        let segment = user2.gender == "Man" ? 0 : 1
        genderSegmented.selectedSegmentIndex = segment
        // configuramos el nombre del usuario
        let name: String = user2.name!
        userLabel.text = "User: " + name
        // configuramos las preguntas seleccionadas
        selectedQuestions[0] = Int(user2.activityQuestion)
        selectedQuestions[1] = Int(user2.goalQuestion)
        selectedQuestions[2] = Int(user2.distributionQuestion)
    }
    
    // Configurar si se habilita el boton de actualizacion
    func enableDataUpdateButton() {
        let isEnable = selectedQuestions[0] == user2.activityQuestion && selectedQuestions[1] == user2.goalQuestion && selectedQuestions[2] == user2.distributionQuestion && age == user2.age && weight == user2.weight && height == user2.height && genders[genderSegmented.selectedSegmentIndex] == user2.gender
        
        navigationItem.rightBarButtonItem?.isEnabled = !isEnable
    }
    
    //MARK: Acciones de la vista
    //Actualizamos los valores del pickerView en caso de modificar la edad
    @IBAction func modifyAgeTextField(_ sender: Any) {
        textFieldActive = .age
        pickerView.reloadAllComponents()
    }
    
    //Actualizamos los valores del pickerView en caso de modificar el peso
    @IBAction func modifyWeightTextField(_ sender: Any) {
        textFieldActive = .weight
        pickerView.reloadAllComponents()
    }
    
    // En caso de mover la Slider
    @IBAction func modifyHeightSlider(_ sender: UISlider) {
        heightLabel.text = "\(Int(sender.value)) cm"
        height = Int(sender.value)
        enableDataUpdateButton() /***Configurar si se habilita el boton de actualizacion */
    }
    
    //Cambiamos el genero del usuario
    @IBAction func modifyGenderSegmentedControl(_ sender: UISegmentedControl) {
        enableDataUpdateButton() /***Configurar si se habilita el boton de actualizacion */
    }
}

//MARK: Extension para el Data Source de la tableView
extension ModifyDailyCaloriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        titles.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titles[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Depende de la pregunta estaran diferentes respuestas
        switch section {
        case 0:
            return activityOptions.count
        case 1:
            return goalOptions.count
        default:
            return nutrientsDistributionOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCalculateCaloriesTVC", for: indexPath) as! OptionCalculateCaloriesTableViewCell
        cell.delegate = self
        //Indica que celda en cada seccion esta seleccionada
        let isSelected = selectedQuestions[indexPath.section] == indexPath.row ? true : false
        switch indexPath.section {
            //Actualizar la celda dependiendo de que pregunta sea
        case 0:
            cell.updateCell(option: activityOptions[indexPath.row], isSelected: isSelected)
        case 1:
            cell.updateCell(option: goalOptions[indexPath.row], isSelected: isSelected)
        default:
            cell.updateCell(option: nutrientsDistributionOptions[indexPath.row], isSelected: isSelected)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 90
        case 1:
            return 120
        default:
            return 100
        }
    }
}

//MARK: Extension para el Delegado de la TableView
extension ModifyDailyCaloriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: Delegado de la celda del tableView
extension ModifyDailyCaloriesViewController: OptionCalculateCaloriesTableViewCellDelegate {
    //recebimos la celda seleccionada
    func optionCalculateCaloriesTableViewCell(_ cell: OptionCalculateCaloriesTableViewCell) {
        let question = tableView.indexPath(for: cell)
        selectedQuestions[question!.section] = question!.row /***Modificamos que boton esta seleccionado de cada seccion*/
        tableView.reloadData()
        enableDataUpdateButton() /***Configurar si se habilita el boton de actualizacion */
    }
}

//MARK: Delegado y Data Source del Picker View
extension ModifyDailyCaloriesViewController:  UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //Determinamos el numero de componentes dependiendo si se ingresara edad o peso
        switch textFieldActive {
        case .age :
            return 1
        case .weight:
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //Determinamos el numero de filas  dependiendo si se ingresara edad o peso
        switch textFieldActive {
        case .age :
            return line1PV.count
        case .weight:
            switch component {
            case 0:
                return line2PV.count
            case 1:
                return line3PV.count
            default:
                return 1
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //Determinamos el texto para cada fila dependiendo si se ingresara edad o peso
        switch textFieldActive {
        case .age :
            return line1PV[row]
        case .weight:
            switch component {
            case 0:
                return line2PV[row]
            case 1:
                return line3PV[row]
            default:
                return "kg"
            }
        }
    }
    
    //MARK: Seleccion de una fila del pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch textFieldActive {
            //Actualizamos valores en caso de modificar la edad
        case .age :
            yearsTextField.text = line1PV[row]
            age = Int(line1PV[row]) ?? 0
            yearsTextField.resignFirstResponder()
        case .weight :
            //Actualizamos valores en caso de modificar el peso
            switch component {
            case 0:
                weightPart1 = Int(line2PV[row])!
            case 1:
                weightPart2 = line3PV[row]
            default:
                print("")
            }
            weightTextField.text = "\(weightPart1)" + weightPart2
            weight = Double("\(weightPart1)" + weightPart2) ?? 0.0
            weightTextField.resignFirstResponder()
        }
        enableDataUpdateButton() /***Configurar si se habilita el boton de actualizacion */
    }
}


