//
//  AccountPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 25/05/23.
//
//MARK: INFO:
/*Vista para poder presentar y modificar la informacion diaria del ususrio como su consumo de ingredientes, recetas y su informacion nutrimental*/

import UIKit
import Lottie
import CoreData

class AccountPageViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var selectedDateLabel: UILabel!
    @IBOutlet var rightButtonDate: UIButton!
    @IBOutlet var leftButtonDate: UIButton!
    
    //MARK: Inicializaciones generles
    private let managerRecipe = CoreDataRecipe() /***Manager para CoreData*/
    private let managerIngredient = CoreDataIngredient() /***Manager para CoreData*/
    private let managerUser = CoreDataUsers() /***Manager para CoreData*/
    var recipeDetail: RecipeDetail! /***Cuando se tenga la informacion de la receta por medio del id se pasara a esta variable */
    let today = Calendar.current.startOfDay(for: Date())/***Fecha del dia presente*/
    var selectedDateCurrent = 0 /***Conteo de dias*/
    var selectedDate = Calendar.current.startOfDay(for: Date()) /***Fecha del dia seleccionado*/
    //Total de recetas e ingredientes en CoreData
    var allRecipes = [RecipeEntity]()
    var allIngredients = [IngredientID2Entity]()
    //Total de recetas e ingredientes de la fecha seleccionada
    var recipesSelectedDay = [RecipeEntity]()
    var ingredientsSelectedDay = [IngredientID2Entity]()
    var users = [UserEntity]()
    var tableViewImageTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    let backgroundImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la receta o ingrediente no tenga imagen, se colocara esta*/
    //Informacion nutrimental principal
    var kcalTotal: Double = 1400
    var carbsTotal = 180
    var proteinTotal = 100
    var fatTotal = 25
    //let userVeggieSoul = UserVS(activity: 1, age: 21, distribution: 2, gender: "Man", goal: 2, height: 167, name: "userVeggieSoul", weight: 65, kCalories: 2000, carbohydrates: 250, fats: 85, proteins: 190)
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        //Eliminar las nuevas recetas e ingredientes recien agregadas en CoreData
        deleteRecentRecipes()
        deleteRecentIngredients()
        // Actualizamos las recetas e ingredientes consumidos en un dia especifico
        updateRecipesForSelectedDay(today)
        updateIngredientsForSelectedDay(today)
        updateNutrients() /***Actualiza la informacion nutrimental del dia*/
        setUpTableView()
        updateDate()
        setUpTitle ()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Guardamos todas las recetas e ingredientes de Core Data
        allRecipes = managerRecipe.fetchRecipes()
        allIngredients = managerIngredient.fetchIngredients()
        self.tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        //Actualizamos las recetas e ingredientes consumidos en un dia especifico
        updateRecipesForSelectedDay(selectedDate)
        updateIngredientsForSelectedDay(selectedDate)
        
        updateNutrients()/***Actualiza la informacion nutrimental del dia*/
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Eliminar las nuevas recetas e ingredientes recien agregadas en CoreData
        deleteRecentRecipes()
        deleteRecentIngredients()
        tabBarController?.tabBar.items?[2].badgeValue = nil
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
    
    //MARK: Eliminar las nuevas recetas e ingredientes recien agregadas en CoreData
    func deleteRecentRecipes (){
        //Se eliminan las nuevas agregadas
        CoreDataRecipe.shared.newRecipes.removeAll()
        allRecipes = managerRecipe.fetchRecipes()
    
    }
    func deleteRecentIngredients () {
        //Se eliminan los nuevo agregados
        CoreDataIngredient.shared.newIngredients.removeAll()
        allIngredients = managerIngredient.fetchIngredients()
    }
    
    //MARK: Actualizamos las recetas e ingredientes consumidos en un dia especifico
    func updateRecipesForSelectedDay(_ date: Date){
        //registrar las recetas consumidas del dia indicado
        recipesSelectedDay.removeAll()
        allRecipes.forEach { recipe in
            if date == recipe.date {
                recipesSelectedDay.append(recipe)
            }
        }
    }
    func updateIngredientsForSelectedDay(_ date: Date){
        //registrar los ingredientes consumidos del dia indicado
        ingredientsSelectedDay.removeAll()
        allIngredients.forEach { ingredient in
            if date == ingredient.date {
                ingredientsSelectedDay.append(ingredient)
            }
        }
    }
    
    //MARK: Actualiza la informacion nutrimental del dia
    func updateNutrients(){
        /*Se suman todas las calorias, proteinas, grasas y carbohidratos consumidos de cada ingrediente o receta del dia seleccionado*/
        kcalTotal = 0
        carbsTotal = 0
        proteinTotal = 0
        fatTotal = 0
        //Registramos la informacion nutricional para la primera celda
        //Para las recetas:
        recipesSelectedDay.forEach{ recipe in
            let nutrition = managerRecipe.fetchRecipeNutrition(recipe: recipe)
            //let nutritionFirts = nutrition.first!
            let nutrients = managerRecipe.fetchRecipeNutritionFlavonoid(nutrition: nutrition)
            nutrients.forEach { item in
                switch item.name {
                case "Calories":
                    kcalTotal += item.amount
                case "Protein":
                    proteinTotal += Int(item.amount)
                case "Fat", "Saturated Fat", "Trans Fat", "Mono Unsaturated Fat", "Poly Unsaturated Fat":
                    fatTotal += Int(item.amount)
                case "Carbohydrates", "Net Carbohydrates":
                    carbsTotal += Int(item.amount)
                default: break
                }
            }
        }
        // para los ingredientes
        ingredientsSelectedDay.forEach{ ingredient in
            let nutrients = managerIngredient.fetchIngredientNutrients(ingredient: ingredient)
            nutrients.forEach{ item in
                switch item.name {
                case "Calories":
                    kcalTotal += item.amount
                case "Protein":
                    proteinTotal += Int(item.amount)
                case "Fat", "Saturated Fat", "Trans Fat", "Mono Unsaturated Fat", "Poly Unsaturated Fat":
                    fatTotal += Int(item.amount)
                case "Carbohydrates", "Net Carbohydrates":
                    carbsTotal += Int(item.amount)
                default: break
                }
            }
        }
    }
    
    //MARK: Registar las celdas ocupadas, data Source y el delegado de tabelView
    func setUpTableView() {
        //Asignamos el delegado y data source de tableView
        tableView.delegate = self
        tableView.dataSource = self
        //Se registran las celdas a ocupar
        tableView.register(UINib(nibName: "NutrientChartTableViewCell", bundle: .main), forCellReuseIdentifier: "NutrientChartTVC")
        tableView.register(UINib(nibName: "RecipeAndIngredientsTableViewCell", bundle: .main), forCellReuseIdentifier: "RecipeAndIngredientsTVC")
    }
    
    func updateDate() {
        
        selectedDateLabel.text = dateFormetter(date: today)
        rightButtonDate.isEnabled = false
    }
    
    //Regresa la fecha en ingles
    func dateFormetter(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let formattedDate = dateFormatter.string(for: date) ?? ""
        return formattedDate
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        navigationItem.title = "DAILY FOOD"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
    }
    
    //MARK: Acciones para elegir fecha
    @IBAction func selectPreviousDate(_ sender: UIButton) {
        selectedDateCurrent -= 1
        rightButtonDate.isEnabled = true
        //Obtenemos la fecha seleccionada y la presentamos
        selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateCurrent, to: today)!
        selectedDateLabel.text = dateFormetter(date: selectedDate)
        //Actualizamos las recetas e ingredientes consumidos en un dia especifico
        updateRecipesForSelectedDay(selectedDate)
        updateIngredientsForSelectedDay(selectedDate)
        updateNutrients() /***Actualiza la informacion nutrimental del dia*/
        tableView.reloadData()/***Mostramos los nuevos datos del dia especifico*/
    }
    
    @IBAction func selectLaterDate(_ sender: UIButton) {
        selectedDateCurrent += 1
        if selectedDateCurrent == 0 {
            sender.isEnabled = false
        }
        //Obtenemos la fecha seleccionada y la presentamos
        selectedDate = Calendar.current.date(byAdding: .day, value: selectedDateCurrent, to: today)!
        selectedDateLabel.text = dateFormetter(date: selectedDate)
        //Actualizamos las recetas e ingredientes consumidos en un dia especifico
        updateRecipesForSelectedDay(selectedDate)
        updateIngredientsForSelectedDay(selectedDate)
        updateNutrients() /***Actualiza la informacion nutrimental del dia*/
        tableView.reloadData() /***Mostramos los nuevos datos del dia especifico*/
    }
}

//MARK: Extension para el Delegado y Data Source de la Table View
extension AccountPageViewController: UITableViewDelegate, UITableViewDataSource {
    //Son tres secciones diferentes, con dos tipos de celda diferente
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return recipesSelectedDay.count + 1
        default:
            return ingredientsSelectedDay.count + 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            //Para presentar la celda con el progreso nutricional del dia
            let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientChartTVC", for: indexPath) as! NutrientChartTableViewCell
            //Configuramos los valores nutricionales de la celda
            cell.updateNutrients()
            cell.updateAmounts(carbs: carbsTotal, protein: proteinTotal, fat: fatTotal)
            cell.updateProgresViews(carbs: carbsTotal, protein: proteinTotal, fat: fatTotal)
            cell.createPieChartView(kcalConsumed: kcalTotal)
            cell.delegate = self
            return cell
        case 1:
            //Para presentar los ingredientes consumidos ese dia
            let cell  = tableView.dequeueReusableCell(withIdentifier: "RecipeAndIngredientsTVC", for: indexPath) as! RecipeAndIngredientsTableViewCell
            guard indexPath.row != recipesSelectedDay.count else {
                //Mostar una celda con informacion neutra de esta seccion
                cell.updateLabelsForRecipe(name: "Add Recipe", portions: 0)
                cell.hiddenAccessory()
                cell.recipeOrIngredientImage.image = UIImage(systemName: "fork.knife")
                return cell
            }
            //Configurar los valores del ingrediente en la celda
            let cellRecipe = updateCellRecipe(cell, indexPath: indexPath)
            return cellRecipe
        default:
            //Para presentar las recetas consumidas ese dia
            let cell  = tableView.dequeueReusableCell(withIdentifier: "RecipeAndIngredientsTVC", for: indexPath) as! RecipeAndIngredientsTableViewCell
            guard indexPath.row != ingredientsSelectedDay.count else {
                //Mostar una celda con informacion neutra de esta seccion
                cell.updateLabelsForIngredient(name: "Add Ingredient", portions: 0)
                cell.hiddenAccessory()
                cell.recipeOrIngredientImage.image = UIImage(systemName: "fork.knife")
                return cell
            }
            //Configurar los valores de la receta en la celda
            let cellIngredient = updateCellIngredient(cell, indexPath: indexPath)
            return cellIngredient
        }
    }
    
    // Configurar los valores del ingrediente en la celda
    func updateCellIngredient(_ cell: RecipeAndIngredientsTableViewCell, indexPath: IndexPath) -> RecipeAndIngredientsTableViewCell {
        //Establecer los labels de la celda
        let name =  ingredientsSelectedDay[indexPath.row].name!
        let portions = Int16(ingredientsSelectedDay[indexPath.row].amount)
        cell.updateLabelsForIngredient(name: name, portions: portions)
        //Establecer la imagen del ingrediente
        let image =  ingredientsSelectedDay[indexPath.row].image
        cell.showAccessory()
        self.tableViewImageTasks[indexPath] =  Task.init {
            //Realizamos una solicitud de red para obtener la imagen
                let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: image!, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
                if let image = try? await sendRequest(fetchIngredientImage) {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        //Se agrega la imagen a la celda
                        cell.recipeOrIngredientImage.image = image
                        cell.recipeOrIngredientImage.contentMode = .scaleAspectFit
                    }
                }
            self.tableViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
        }
        return cell
    }
    // Configurar los valores de la receta en la celda
    func updateCellRecipe(_ cell: RecipeAndIngredientsTableViewCell, indexPath: IndexPath) -> RecipeAndIngredientsTableViewCell {
        //Establecer los labels de la celda
        let name = recipesSelectedDay[indexPath.row].nameRecipe!
        let portions = recipesSelectedDay[indexPath.row].servings
        cell.updateLabelsForRecipe(name: name, portions: portions)
        //Establecer la imagen del ingrediente
        let image = recipesSelectedDay[indexPath.row].image
        cell.showAccessory()
        self.tableViewImageTasks[indexPath] =  Task.init {
            //Realizamos una solicitud de red para obtener la imagen
                let fetchRecipeImage = FetchRecipeImage(url: image ?? self.backgroundImageURL) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de la receta*/
                if let image = try? await sendRequest(fetchRecipeImage) {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        //Se agrega la imagen a la celda
                        cell.recipeOrIngredientImage.image = image
                        cell.recipeOrIngredientImage.contentMode = .scaleAspectFill
                    }
                    
                }
            self.tableViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
        }
        return cell
    }
    //Las celdas de cada seccion tienen diferente tamaño
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 430
        case 1, 2:
            return 100
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 430
        case 1, 2:
            return 100
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return "Recipes"
        case 2:
            return "Ingredients"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Se redijira a la vista AddFood solo al presionar la seccion de los ingredientes o recetas
        switch indexPath.section {
        case 1:
            //Si se presiona la ultima celda se enviara a AddFood sin receta
            if indexPath.row == recipesSelectedDay.count {
                gotoAddFoodView(false, recipe: nil, ingredient: nil)
            } else {
                let recipe = recipesSelectedDay[indexPath.row]
                gotoAddFoodView(false, recipe: recipe, ingredient: nil)
            }
        case 2:
            //Si se presiona la ultima celda se enviara a AddFood sin ingrediente
            if indexPath.row == ingredientsSelectedDay.count {
                gotoAddFoodView(true, recipe: nil, ingredient: nil)
            } else {
                let ingredient = ingredientsSelectedDay[indexPath.row]
                gotoAddFoodView(true, recipe: nil, ingredient: ingredient)
            }
        default:
            return
        }
    }
    //Se dirije a la vista AddFood con un ingrediente, receta o ninguno
    func gotoAddFoodView(_ areLookingIngredients: Bool, recipe: RecipeEntity?, ingredient: IngredientID2Entity?) {
        // instanciamos una vista para presentarla
        let addFoodStoryboard = UIStoryboard(name: "AddFood", bundle: .main)
        //Instanciamos un nutritionalInformationDailyFoodViewController
        if let addFoodViewController = addFoodStoryboard.instantiateViewController(withIdentifier: "AddFoodVC") as? AddFoodViewController {
            addFoodViewController.areLookingIngredients = areLookingIngredients
            addFoodViewController.date = selectedDate
            //Si se envia con alguna receta para modificar
            if let recipe = recipe {
                //Se envia la receta seleccionada
                let portion = recipe.servings > 1 ? "Portions" : "Portion"
                let recipeFood = Food(name: recipe.nameRecipe! , id: Int(recipe.id), image: "jpg", units: portion , amount: Double(recipe.servings))
                addFoodViewController.recipes.append(recipeFood)
                addFoodViewController.recipeEntity = recipe
            }
            //Si se envia con algun ingrediente para modificar
            if let ingredient = ingredient {
                //SE envia el ingrediente seleccionado
                let ingredientFood = Food(name: ingredient.name!, id: Int(ingredient.id), image: ingredient.image!, units: "g", amount: Double(ingredient.amount))
                addFoodViewController.ingredients.append(ingredientFood)
                addFoodViewController.ingredientEntity = ingredient
            }
            // realizamos la presentacion de tipo push para la siguiente vista
            navigationController?.pushViewController(addFoodViewController, animated: true)
        }
    }
}

//MARK: Delegados de los botones de la primera celda de la primera seccion
extension AccountPageViewController: NutrientChartTableViewCellDelegate {
    //Modificar los datos del usuario para modificar las calorias diarias
    func nutrientChartTableViewCellToCalories(tableViewCell: NutrientChartTableViewCell) {
        let modifyDailyCaloriesStoryboard = UIStoryboard(name: "ModifyDailyCalories", bundle: .main)
        //Instanciamos un modifyDailyCaloriesViewController
        if let modifyDailyCaloriesViewController = modifyDailyCaloriesStoryboard.instantiateViewController(withIdentifier: "ModifyDailyCaloriesVC") as? ModifyDailyCaloriesViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            let users = managerUser.fetchUsers()
            //modifyDailyCaloriesViewController.user = userVeggieSoul
            modifyDailyCaloriesViewController.user2 = users.last
            //nutritionalInformationDailyFoodViewController.nutritionalInformationMeals = nutritionalInformationMeals /***Pasamos la informacion nutrimental de las comidas*/
            navigationController?.pushViewController(modifyDailyCaloriesViewController, animated: true)
        }
    }
    //Visualizar la informacion nutrimental de los nutrientes consumidos ese dia
    func nutrientChartTableViewCell(tableViewCell: NutrientChartTableViewCell) {
        let nutritionalInformationMeals = obtainNutritionalInformationAboutMeals() /***informacion nutrimental de las recetas e ingredientes consumidas ese dia*/
        // instanciamos una vista para presentarla
        let nutritionalInformationDailyFoodStoryboard = UIStoryboard(name: "NutritionalInformationDailyFood", bundle: .main)
        //Instanciamos un nutritionalInformationDailyFoodViewController
        if let nutritionalInformationDailyFoodViewController = nutritionalInformationDailyFoodStoryboard.instantiateViewController(withIdentifier: "NutritionalInformationDailyFoodVC") as? NutritionalInformationDailyFoodViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            nutritionalInformationDailyFoodViewController.nutritionalInformationMeals = nutritionalInformationMeals /***Pasamos la informacion nutrimental de las comidas*/
            navigationController?.pushViewController(nutritionalInformationDailyFoodViewController, animated: true)
        }
    }
    //Obtener informacion nutrimental de las recetas e ingredientes consumidas ese dia
    func obtainNutritionalInformationAboutMeals() -> [DailyNutritionalInformation] {
        var nutritionalInformation = [DailyNutritionalInformation]()
        recipesSelectedDay.forEach{ recipe in
            let nutrition = managerRecipe.fetchRecipeNutrition(recipe: recipe)
            //let nutritionFirts = nutrition.first!
            let nutrients = managerRecipe.fetchRecipeNutritionFlavonoid(nutrition: nutrition)
            nutrients.forEach { item in
                let nutrient = DailyNutritionalInformation(name: item.name!, amount: Float(item.amount), unit: item.unit!, percentOfDailyNeeds: item.percentOfDailyNeeds)
                nutritionalInformation.append(nutrient)
            }
        }
        ingredientsSelectedDay.forEach{ ingredient in
            let nutrients = managerIngredient.fetchIngredientNutrients(ingredient: ingredient)
            nutrients.forEach{ item in
                let nutrient = DailyNutritionalInformation(name: item.name!, amount: Float(item.amount), unit: item.unit!, percentOfDailyNeeds: item.percentOfDailyNeeds)
                nutritionalInformation.append(nutrient)
            }
        }
         return nutritionalInformation
    }
}


