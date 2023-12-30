//
//  RecipeDetailViewController.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Vista que nos ayudara a mostrar la informacion detallada de la receta sleccionada */

import UIKit
import Lottie
import SafariServices

class RecipeDetailViewController: UIViewController {
    
    //MARK: Inicializaciones generles
    let backgroundRecipeImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la reeta no tenga imagen, se colocara esta*/
    var id: Int! /***Valor que recibe esta vista de la vista anterior cuando se presiona la recta. Este valor nos ayuda a saber que receta se debe presentar en esta vista*/
    var selectedPortion = 1 /***Numero de porciones que quiere el usuario */
    var unitSystem = UnitSystem.us /***Sistema de unidades que quiera ocupar el usuario*/
    var ingredientsOrInstructions = IngredientsOrInstructions.Ingredients /***Variable para saber si el usuario decide si quere ver las intrucciones o los ingredientes*/
    var recipeDetail: RecipeDetail! /***Cuando se tenga la informacion de la receta por medio del id se pasara a esta variable */
    //private let manager = CoreDataRecipe() /***Manager para CoreData*/
    private let managerRecipe = CoreDataRecipe() /***Manager para CoreData*/
    var date: Date = Calendar.current.startOfDay(for: Date())
    // El usuario decide si quere ver las intrucciones o los ingredientes
    enum IngredientsOrInstructions {
        case Ingredients
        case Instructions
    }
    
    //MARK: PENDIENTE BORRAR
    var name: String!
    
    // MARK: Outlets de la vista
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeTitleLabel: UILabel!
    @IBOutlet var preparationTimeLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var ingredientNumberLabel: UILabel!
    @IBOutlet var calorieNumberLabel: UILabel!
    @IBOutlet var proteinAmountLabel: UILabel!
    @IBOutlet var fullFatLabel: UILabel!
    @IBOutlet var carbohydrateAmountLabel: UILabel!
    @IBOutlet var buttonToAddToFood: UIButton!
    @IBOutlet var buttonToGoToNutritionalInformation: UIButton!
    @IBOutlet var weightPerServingLabel: UILabel!
    @IBOutlet var segmentControlForIngredientsAndInstructions: UISegmentedControl!
    @IBOutlet var servingNumberLabel: UILabel!
    @IBOutlet var stepperForNumberOFServings: UIStepper!
    @IBOutlet var segmentedControlForUnitsOption: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var setIngredientsStackView: UIStackView!
    @IBOutlet var setIngredientsConstraint: NSLayoutConstraint!
    
    //@IBOutlet weak var constructionView: AnimationView!
    
    //MARK: Actualizacion y configuracion de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem ()/***Configura el titulo y botones de navigation item*/
        requestRecipe() /***Solicitamos informacion de la receta*/
        configureButtons () /***Configuramos el diseño de los botones*/
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Recipe"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Solicitamos la receta por su ID y su imagen
    func requestRecipe (){
        let recipe = RecipeDetailSearch(id: id)/***Creamos una instancia con el id para realizar la peticion a la API*/
        Task {
            do {
                let recipe = try await sendRequest(recipe)/***Realizamos la peticion de la receta al API*/
                //Solicitamos la imagen a partir de la peticion anterior
                let fetchRecipeImage = FetchRecipeImage(url: recipe.image ?? self.backgroundRecipeImageURL)
                if let image = try? await sendRequest(fetchRecipeImage){
                    recipeImage.image = image /***Agregamos la imagen obtenida a la vista***/
                }
                recipeDetail = recipe /***Asignamos la receta obtenida a esta variable*/
                //Al valor de "itsAdded" de los ingredientes de esta receta se asigna en false
                for index in 0...(recipeDetail.extendedIngredients.count - 1) {
                    recipeDetail.extendedIngredients[index].itsAdded = false
                }
                updateRecipeDetail(recipe: recipe) /***Actualizamos la informacion obtenida de la receta y la presentamos en pantalla*/
                beforeDataSource() /***Establecer valores iniciales para poder ocuparlor en datasource*/
                configureTableView() /***Cuando se tenga la receta lista se puede configurar la tableview para evitar errores en numero items in section*/
                tableView.reloadData()
            }catch {
                print(error)
            }
        }

    }
    
    //MARK: Actualizamos los detalles de la receta obtenida a la vista
    func updateRecipeDetail(recipe: RecipeDetail){
        //Se agrega la informacion general de la receta a al vista
        recipeTitleLabel.text = recipe.nameRecipe
        likeLabel.text = String(recipe.likes)
        preparationTimeLabel.text = String(recipe.minutes)
        ingredientNumberLabel.text = String(recipe.extendedIngredients.count)
        servingNumberLabel.text = String(recipe.servings) + " portions"
        
        //Agregamos la cantidad de gramos por porcion de la receta
        let weightPerServing = recipe.nutrition.weightPerServing.amount
        let weightPerServingUtnit = recipe.nutrition.weightPerServing.unit
        weightPerServingLabel.text = "Data for 1 portion \(weightPerServing)" + weightPerServingUtnit + " prepared"
        
        //Agregamos informacion basica de los nutrientes importantes de la receta
        recipe.nutrition.nutrients.forEach { nutrient in
            if nutrient.name == "Calories" {
                calorieNumberLabel.text = String(nutrient.amount) + "Kcal"
            }
            if nutrient.name == "Fat" {
                fullFatLabel.text = String(nutrient.amount) + "g"
            }
            if nutrient.name == "Carbohydrates" {
                carbohydrateAmountLabel.text = String(nutrient.amount) + "g"
            }
            if nutrient.name == "Protein" {
                proteinAmountLabel.text = String(nutrient.amount) + "g"
            }
        }
  
    }
    
    //MARK: Actualizar datos antes de presentar el dataSource
    func beforeDataSource() {
        unitSystem = UnitSystem.us /***Asignamos el sistema de US como inicial***/
        stepperForNumberOFServings.value = Double(recipeDetail.servings) /***Se establece el valor de porciones de la receta al stepper*/
        selectedPortion = Int(stepperForNumberOFServings.value)
    }
    
    //MARK: Configuramos el diseño de dos botones
    func configureButtons () {
        //Realizamos un redondeo al boton de agregar a la comida
        buttonToAddToFood.layer.cornerRadius = buttonToAddToFood.frame.height / 3
        //Realizamos  un redondeo al boton de mostrar informacion nutricional y le agreamos un borde de color
        buttonToGoToNutritionalInformation.layer.cornerRadius = buttonToGoToNutritionalInformation.frame.height / 4
        let borderColor = UIColor(named: "Opaque Separator Color")
        buttonToGoToNutritionalInformation.layer.borderColor = borderColor?.cgColor
        buttonToGoToNutritionalInformation.layer.borderWidth = 1
    }
    
    //MARK: Configurar la tableView para los pasos e ingredientes
    func configureTableView() {
        //Registramos las dos celdas a ocupar, uno para los ingredientes y la otra para los pasos
        tableView.register(UINib(nibName: "IngredientDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "IngredientDetailTVC")
        tableView.register(UINib(nibName: "StepDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "StepDetailTVC")
        //Establecemos el responsable del tata source y del delegado del tableVie
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    //MARK: Actaulizar tableView por medio de acciones
    //Por cambiar el numero de porciones de la receta
    @IBAction func changeNumberOfServings(_ sender: Any) {
        selectedPortion = Int(stepperForNumberOFServings.value)
        servingNumberLabel.text = "\(Int(stepperForNumberOFServings.value)) Portions"
        tableView.reloadData()/***Cuando se cambie el numero de porciones de requiere actalizar para ver los cabios en el numero de porciones en los ingredientes*/
    }
    
    //Por cambiar el sistem de unidades
    @IBAction func changeSystemUnit(_ sender: Any) {
        unitSystem = segmentedControlForUnitsOption.selectedSegmentIndex == 0 ? UnitSystem.us : UnitSystem.metric
        tableView.reloadData() /***Cuando se cambia unitSystem se actualiza el tabel view para ver los cambios del sistema de unidades*/
    }
    
    //Para saber si se quiere mostrar los ingredientes o los pasos de la receta
    @IBAction func chooseBetweenIngredientsOrInstructions(_ sender: Any) {
        ingredientsOrInstructions = segmentControlForIngredientsAndInstructions.selectedSegmentIndex == 0 ? IngredientsOrInstructions.Ingredients : IngredientsOrInstructions.Instructions /***Se determina si se quiere ver los ingredientes o los pasos de la receta en la tableView*/
        parameterDisplayForIngredients()/***Se determina si se oculta o aparecen unas vistas para configurar el tableView*/
        tableView.reloadData()
        
    }
    
    func parameterDisplayForIngredients(){
        setIngredientsStackView.isHidden.toggle()/***La vista para modificar el sistema de unidades y el numero de porciones, cambia su visibilidad*/
        var height: CGFloat
        /*Dependiendo si esta visible la lista de los ingredientes o el de los pasos, la altura de la vista encargada de poder cambiar el sistema de unidades y el numero de porciones cambiara de valor para poder ser vista o no*/
        switch ingredientsOrInstructions {
        case .Ingredients:
            height = 32
        case .Instructions:
            height = 0
        }
        setIngredientsConstraint.constant = height
    }
    
    //MARK: Ver la informacion nutrimental de la receta
    @IBAction func SeeNutritionalInformation(_ sender: UIButton) {
        /***En caso de que se presione el boton de "Nutritional Information" de la receta se podra ver los detalle de la misma en otra vista*/
            // instanciamos una vista para presentarla
            let recipeNutritionalInformation = UIStoryboard(name: "RecipeNutritionalInformation", bundle: .main)
            //Instanciamos un recipeNutritionalInformationViewController
            if let recipeNutritionalInformationViewController = recipeNutritionalInformation.instantiateViewController(withIdentifier: "RecipeNutritionalInformationVC") as? RecipeNutritionalInformationViewController {
                recipeNutritionalInformationViewController.recipeNutrition = recipeDetail.nutrition /***Se envia la informacion nutricional de la receta */
                recipeNutritionalInformationViewController.portions = Int(stepperForNumberOFServings.value)
                // realizamos la presentacion de tipo push para la siguiente vista
                self.navigationController?.pushViewController(recipeNutritionalInformationViewController, animated: true)
            }
    }
    
    
    //MARK: Guardar la receta en CoreDataRecipe
    @IBAction func AddToFoodButton(_ sender: UIButton) {
        //Dependiendo de las porciones seleccionadas, aparecera una alerta diferente
        switch selectedPortion {
        case 1:/***En caso de haber seleccionada una porcion*/
            let alertController = UIAlertController(title: "ADD RECIPE", message: "Do you want to add only 1 portion ?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let alertAction2 = UIAlertAction(title: "Accept", style: .default, handler: { action in
                //Agregar una porcion de la receta en CoreData
                self.AddFoodToCoreData(portions: 1)
            })
            alertController.addAction(alertAction)
            alertController.addAction(alertAction2)
            alertController.popoverPresentationController?.sourceView = sender
            present(alertController, animated: true, completion: nil) /***Presentamos la alerta con 2 acciones*/
        default: /***En caso de haber seleccionado mas de una porcion*/
            let alertController = UIAlertController(title: "ADD RECIPE", message: "Do you want to add \(selectedPortion) portions?", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let alertAction2 = UIAlertAction(title: "Accept", style: .default, handler: { action in
                //Agregar las porciones seleccionadas de la receta en CoreData
                self.AddFoodToCoreData(portions: Double(self.selectedPortion))
            })
            let alertAction3 = UIAlertAction(title: "Add only 1 portion", style: .default, handler: { action in
                //Agregar una porcion de la receta en CoreData
                self.AddFoodToCoreData(portions: 1)
            })
            alertController.addAction(alertAction)
            alertController.addAction(alertAction2)
            alertController.addAction(alertAction3)
            alertController.popoverPresentationController?.sourceView = sender
            present(alertController, animated: true, completion: nil)  /***Presentamos la alerta con 3 acciones*/

        }
    }
    // metodo para agregar la receta con las porciones seleccionadas a CoreData
    func AddFoodToCoreData(portions: Double){
        //modificamos los valores de los nutrientes de la receta en base a las porciones seleccionadas
        var nutricion = RecipeNutrition(nutrients: [], weightPerServing: recipeDetail.nutrition.weightPerServing)
        recipeDetail.nutrition.nutrients.forEach{ nutrient in
            nutricion.nutrients.append(Flavonoid(name: nutrient.name, amount: (nutrient.amount * portions), unit: nutrient.unit, percentOfDailyNeeds: (nutrient.percentOfDailyNeeds! * portions)))
        }
        //modificamos los valores de la cantidad de ingredientes de la receta en base a las porciones seleccionadas
        var ingredients = recipeDetail.extendedIngredients
        for ingredient in 0 ..< ingredients.count {
            ingredients[ingredient].itsAdded = nil
            ingredients[ingredient].measures.metric.amount *= portions
            ingredients[ingredient].measures.us.amount *= portions
        }
        //Creamos una nueva receta con los nuevos valores
        var newRecipe = recipeDetail
        newRecipe?.servings = Int(portions)
        newRecipe?.nutrition = nutricion
        newRecipe?.extendedIngredients = ingredients
        //Guardamos la nueva receta modificada en CoreData
        CoreDataRecipe.shared.newRecipes.append(newRecipe!)
        managerRecipe.saveRecipe(recipe: newRecipe!, date: date)
    }
}


//MARK: Extension con metodos del DataSource de la tableView
extension RecipeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*Dependiendo si se quiere ver la lista de los ingredientes o de los pasos cambiara el numero de retorno*/
        switch ingredientsOrInstructions {
        case .Ingredients:
            return recipeDetail.extendedIngredients.count
        case .Instructions:
            if recipeDetail.instructions?.count == 0 {
                /*En caso que se quiera ver los pasos pero la receta no tenga ninguno, se regresara solo una celda con un mensaje*/
                return 1
            } else {
                return (recipeDetail.instructions?[0].steps.count)!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*Dependiendo si se quiere ver la lista de los ingredientes o de las instrucciones cambiara el tipo de celda que se retornara*/
        switch ingredientsOrInstructions {
        //En caso que se quieran ver los ingredientes
        case .Ingredients:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientDetailTVC", for: indexPath) as! IngredientDetailTableViewCell
            let ingredient = recipeDetail.extendedIngredients[indexPath.row]
            cell.updateCell(ingredient: ingredient, unitSystem: unitSystem, originalPortions: Double(recipeDetail.servings), selectedPortions: Double(selectedPortion)) /***En caso de ver la lista de los ingredientes se debe actualizar la celda enviando el ingrediente, el sistema de unidades que se quiera ver en la lista y tambien la informacion para poder mostrar la cantidad de ese ingrediente dependiendo el numero de porciones que quiera el usuario*/
            let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: ingredient.image ?? "asparagus.png", isIngredient: true) /***Se obtiene el tipo on la informacion de la imagen del ingrediente*/
            cell.delegate = self/***Delegado para selecionar los ingredientes que ya se tienen*/
            /*Tarea para poder obtener la imagen del ingrediente*/
            Task {
                if let image = try? await sendRequest(fetchIngredientImage) {
                    if let currentIndexPath = tableView.indexPath(for: cell), currentIndexPath == indexPath {
                        cell.ingredientImage.image = image
                    }
                }
            }
            return cell
        //En caso que se quiera ver los pasos para realizar la receta
        case .Instructions:
            if recipeDetail.instructions?.count == 0 {
                /*En caso que la receta no cuente con pasos a seguir*/
                let cell = tableView.dequeueReusableCell(withIdentifier: "StepDetailTVC", for: indexPath) as! StepDetailTableViewCell
                cell.delegate = self
                cell.configureCellWithoutInstructions() /***La celda se configurara para poder mostrar un texto y un boton para poder ver los pasos en una pagina de internet*/
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "StepDetailTVC", for: indexPath) as! StepDetailTableViewCell
                let step = recipeDetail.instructions![0].steps[indexPath.row]
                cell.configureCell(step: step) /***Configuramos la celda con el respectivo paso a segir*/
                return cell
            }
        }
    }
}

//MARK: Delegado para poder marcar el ingrediente que ya tiene el usuario
extension RecipeDetailViewController: IngredientDetailTableViewCellDelegate {
    func ingredientDetailTableViewCell(cell: IngredientDetailTableViewCell) {
        if let indexPat = tableView.indexPath(for: cell){
             var ingredient = recipeDetail.extendedIngredients[indexPat.row] /***Encontramos el ingrediente por medio del indexPath que se seleciono*/
            ingredient.itsAdded?.toggle() /***Se cambia la imagen del boton dependiendo si esta seleccionano o no*/
            recipeDetail.extendedIngredients[indexPat.row] = ingredient /***Se asigna el ingredinte el la posicion seleccionada*/
            tableView.reloadData()
        }
    }
}

//MARK: Delegado para mostrar los pasos de la recta en una pagina de internet
extension RecipeDetailViewController: StepDetailTableViewCellDelegate {
    func stepDetailTableViewCell(cell: StepDetailTableViewCell) {
        /*En caso que la receta no tenga pasos, se podra mostar un boton que redirige a una pagina de internet donde se puedan mostrar*/
        guard let url = URL(string: recipeDetail.creditURL!) else {return}
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true, completion: nil)
    }
}


//MARK: Extension con metodos del Delegate de la tableView
extension RecipeDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
