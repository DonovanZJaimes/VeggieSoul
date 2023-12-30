//
//  AddFoodViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Vista para poder presentar una tableView y un searchController donde se podra buscar y mostrar las recetas o ingredientes seleccionados*/

import UIKit
import CoreData
import Lottie

class AddFoodViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addFoodButton: UIButton!
    @IBOutlet var selectionBarView: UIView!
    @IBOutlet var ingredientsButton: UIButton!
    @IBOutlet var recipesButton: UIButton!
    @IBOutlet var loadAnimation: AnimationView! /***Animacion para mostar un circulo de carga*/
    
    //MARK: Inicializaciones generles
    let searchController = UISearchController(searchResultsController: FoodSearchListViewController())/***Asignamos que controlador presentara el searchController al ser presionado*/
    private let managerRecipe = CoreDataRecipe() /***Manager para CoreData*/
    private let managerIngredient = CoreDataIngredient() /***Manager para CoreData*/
    var areLookingIngredients: Bool! /***Se verifica que se estara buscando*/
    var ingredients = [Food]() /***Ingredientes que puede enviar AccountPage*/
    var recipes = [Food]() /***Recetas que puede enviar AccountPage*/
    var tableViewTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    let starterIngredient = Ingredient(id: 9266, imagePNG: "pineapple.jpg", name: "pineapples")/***En caso de que la primera receta en pantalla no tenga ingredientes se pondra ese en la primera fila, esto para que la primera seccion no se quede vacia */
    var date: Date! /***Fecha que envia AccountPage*/
    var recipeEntity: RecipeEntity?
    var ingredientEntity: IngredientID2Entity?
    var allRecipes = [RecipeEntity]() /***Sera para todas las recetas de CoreData*/
    var allIngredients = [IngredientID2Entity]()  /***Sera para todos los ingredientes de CoreData*/
    
    
    //MARK: Tipo de busqueda
    //Definir que tipo de busqueda se realizara, por ingredientes o por recetas
    enum SearchType {
        case recipes /***Opcion para buscar por el nombre de rectas*/
        case ingredients /***Opcion para buscar por el nombre de ingredientes*/
    }
    var activeSearchType: SearchType = .ingredients /***Se menciona cual tipo de busqueda se esta realizando*/
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController() /***Actualizamos el search controller para poder hacer las busquedas*/
        activeSearchType = areLookingIngredients == true ? .ingredients : .recipes /***Asignamos que tipo de busqueda se esta haciendo*/
        animateLineBetweenButtons(buttonWidth: ingredientsButton.bounds.width , direction: activeSearchType) /***Movemos la linea dependido el tipo de busqueda actual*/
        configureTableView()
        configureNavigationItem () /***Configuramos el boton y el titulo de navigation item */
        setUpFoodButton()
        //print(date)
        allRecipes = managerRecipe.fetchRecipes() /***Agregamos todas las recetas de CoreData*/
        allIngredients = managerIngredient.fetchIngredients() /***Agregamos todos los ingredientes de CoreData*/
    }
    
    //MARK: Configuramos la table view
    func configureTableView() {
        view.addSubview(tableView) /***Agregamos la tableView a la vista del viewController*/
        //Asignamos el delegado y e dataSorce de tableView
        tableView.delegate = self
        tableView.dataSource = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "AddFoodTableViewCell", bundle: .main), forCellReuseIdentifier: "AddFoodTVC")
        
    }
    
    //MARK: Actualizar el search Controller
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
    
    //MARK: Animacion para cmbio entre ingredientes y receta
    func animateLineBetweenButtons(buttonWidth: CGFloat, direction: SearchType) {
        var translationInX: CGFloat = 0
        //Verificamos a que direccion  se debe mover la linea
        switch direction {
        case .recipes:
            translationInX = buttonWidth + 20 /***Si la direccion es hacia el boton de las recetas */
            /***El numero 20 corresconde a la distancia entre los botone en el storyboard*/
        case .ingredients:
            translationInX = 0 /***Si la direccion es hacia el boton de los ingredientes */
        }
        UIView.animate(withDuration: 0.5) {
            //la animacion dura 0.5s y se movera dependiendo el boton que se presiono
            self.selectionBarView.transform = CGAffineTransform.init(translationX: translationInX, y: 0)
        }
    }
    
    //MARK: Establecer el tipo de busqueda
    // se presiona boton para mostrar los ingredientes
    @IBAction func selectIngredientsForSearchWithButton(_ sender: UIButton) {
        //self.searchController.searchBar.resignFirstResponder()
        activeSearchType = .ingredients /***Hacer que cada vez que se presione esta boton  el modo de busqueda sea por ingredientes*/
        animateLineBetweenButtons(buttonWidth: sender.bounds.width, direction: activeSearchType)/***Realizamos una animacion pra la view que esta debajo de los botones de ingredientes y recetas*/
        editFoodButton()
        tableView.reloadData()
        
    }
    // se presiona boton para mostrar las recetas
    @IBAction func selectRecipesForSearchWithButton(_ sender: UIButton) {
        //self.searchController.searchBar.resignFirstResponder()
        activeSearchType = .recipes /***Hacer que cada vez que se presione esta boton  el modo de busqueda sea por ingredientes*/
        animateLineBetweenButtons(buttonWidth: sender.bounds.width, direction: activeSearchType)/***Realizamos una animacion pra la view que esta debajo de los botones de ingredientes y recetas*/
        editFoodButton()
        tableView.reloadData()
    }
    
    //MARK: Agregamos la nueva comida al dia en CoreData
    @IBAction func addNewFood(_ sender: UIButton) {
        setUpLoadAnimationView() /***Iniciamos la animacion, en el caso que tarde el guardado*/
        //Dependiendo si se guadara ingredientes o recetas
        switch activeSearchType {
        case .ingredients:
            addNewIngredientsToDiet()
        case .recipes:
            addNewRecipesToDiet()
        }
        stopLoadAnimation() /***Detenemos la animacion*/
    }
    
    //Guardar los nuevos ingredientes con la fecha adecuada en CoreData
    func addNewIngredientsToDiet() {
        //Para todos los ingredientes en la tableView
        for newIngredient in ingredients {
            Task {
                do {
                    //Realizamos una solicitud de red para el ingredinete con amount = 1
                    let ingredientDetailSearch = IngredientDetailSearch(id: newIngredient.id, amount: 1)
                    let ingredient = try await sendRequest(ingredientDetailSearch)/***Solicitamos el ingrediente a la API*/
                    //obtenemos el amount dependiendo de la solicitud anterior y de la cantidad que quiere el usuario
                    let onePercent = Double(ingredient.nutrition.weightPerServing.amount) / 100.0
                    let newAmount = newIngredient.amount / onePercent
                    let percentAmount = newAmount * 0.01
                    //Realizamos una nueva solicitud de red para el ingredinte con un amount especifico
                    let newIngredientDetailSearch = IngredientDetailSearch(id: newIngredient.id, amount: percentAmount)
                    let ingredientWithNewAmount = try await sendRequest(newIngredientDetailSearch)/***Solicitamos el ingrediente a la API*/
                    //Guardamos en CoreData el ingredinete con el amount seleccionado
                    CoreDataIngredient.shared.newIngredients.append(ingredientWithNewAmount) /***Agregar el ingrediente a CoreData*/
                    managerIngredient.saveIngredient(ingredient: ingredientWithNewAmount, date: date)
                    
                } catch {
                    print(error)
                }
            }
        }
        deleteIngredientCoreData()
        ingredients.removeAll()
        tableView.reloadData()
        editFoodButton()
    }
    //Eliminamos el ingrediente que se paso de la vista anterior
    func deleteIngredientCoreData(){
        if let deleteIngredient = ingredientEntity {
            allIngredients.forEach { ingredient in
                //Verificamos si este ingrediente existe
                if deleteIngredient.idU == ingredient.idU {
                    managerIngredient.deleteIngredient(ingredient) /***Lo eliminamos de CoreData*/
                }
            }
        }
    }
    
    //Guardar las nuevas recetas con la fecha adecuada en CoreData
    func addNewRecipesToDiet() {
        //Para todas las recetas en la tableView
        for newRecipe in recipes {
            Task {
                do {
                    //Realizamos una solicitud de red para la receta
                    let recipeDetailSearch = RecipeDetailSearch(id: newRecipe.id)
                    let recipe = try await sendRequest(recipeDetailSearch)
                    //Modificamos la receta para ajustarla a las nuevas porciones seleccionadas
                    let portions = newRecipe.amount
                    //Mofificamos los valores nutrimentales de la receta
                    var nutricion = RecipeNutrition(nutrients: [], weightPerServing: recipe.nutrition.weightPerServing)
                    recipe.nutrition.nutrients.forEach{ nutrient in
                        nutricion.nutrients.append(Flavonoid(name: nutrient.name, amount: (nutrient.amount * portions), unit: nutrient.unit, percentOfDailyNeeds: (nutrient.percentOfDailyNeeds! * portions)))
                    }
                    //Mofificamos los nuevos ingredientes de la receta
                    var ingredients = recipe.extendedIngredients
                    for ingredient in 0 ..< ingredients.count {
                        ingredients[ingredient].itsAdded = nil
                        ingredients[ingredient].measures.metric.amount *= portions
                        ingredients[ingredient].measures.us.amount *= portions
                    }
                    //Configuramos la nueva receta
                    var newRecipe = recipe
                    newRecipe.servings = Int(portions)
                    newRecipe.nutrition = nutricion
                    newRecipe.extendedIngredients = ingredients
                    //Guardamos la nueva receta con los valores seleccionados en CoreData
                    CoreDataRecipe.shared.newRecipes.append(newRecipe)
                    managerRecipe.saveRecipe(recipe: newRecipe, date: date)
                    
                    
                } catch {
                    print(error)
                }
            }
        }
        deleteRecipeCoreData()
        recipes.removeAll()
        tableView.reloadData()
        editFoodButton()
    }
    //Eliminamos la receta que se paso de la vista anterior
    func deleteRecipeCoreData() {
        if let deleteRecipe = recipeEntity {
            allRecipes.forEach { recipe in
                //Verificamos si esta receta existe
                if deleteRecipe.idU == recipe.idU {
                    managerRecipe.deleteRecipe(recipe) /***La eliminamos de CoreData*/
                }
            }
        }
    }
    
    //MARK: Animacion
    //Comenzamos la animacion
    func setUpLoadAnimationView(){
        loadAnimation.isHidden = false
        loadAnimation.animation = Animation.named("LoadingCircle2")
        loadAnimation.loopMode = .loop
        loadAnimation.play()
    }
    //Detenemos la animacion
    func stopLoadAnimation() {
        loadAnimation.stop()
        loadAnimation.isHidden = true
    }
    
    //MARK: Boton de guardado
    //Configuramos el boton
    func setUpFoodButton(){
        addFoodButton.layer.cornerRadius = addFoodButton.frame.height / 4
        editFoodButton() /***Actualizamos su titulo y si esta habilitado*/
    }
    // Actualizamos su titulo y si esta habilitado
    func editFoodButton(){
        addFoodButton.isHidden = false /***habilitamos el boton*/
        //Dependiendo si se esta buscando ingredientes o recetas
        switch activeSearchType {
        case .ingredients:
            switch ingredients.count {
                //Modifcamos el titulo dependiendo de la cantidad de ingredientes
            case 0:
                addFoodButton.isHidden = true
            case 1:
                addFoodButton.setTitle("Add Ingredient", for: .normal)
            default:
                addFoodButton.setTitle("Add Ingredients", for: .normal)
            }
        case .recipes:
            switch recipes.count {
                //Modifcamos el titulo dependiendo de la cantidad de recetas
            case 0:
                addFoodButton.isHidden = true
            case 1:
                addFoodButton.setTitle("Add Recipe", for: .normal)
            default:
                addFoodButton.setTitle("Add Recipes", for: .normal)
            }
        }
    }
    
    
    //MARK: Actualizacion visual extra de la pantalla
    // metodo que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Search"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Daily Food", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    /*
    func convertIngredientCoreData(_ ingredient: IngredientID2Entity ) -> IngredientID{
        var ingredientNutrients = [IngredientNutrients]()
        let nutrients = managerIngredient.fetchIngredientNutrients(ingredient: ingredient)
        nutrients.forEach { item in
            ingredientNutrients.append(IngredientNutrients(name: item.name!, amount: item.amount, unit: item.unit!, percentOfDailyNeeds: item.percentOfDailyNeeds))
        }
        let ingredientWeightPerServing = IngredientWeightPerServing(amount: Int(ingredient.amount), unit: ingredient.unit!)
        let ingredientCaloricBreakdown = IngredientCaloricBreakdown(percentProtein: ingredient.percentProtein, percentFat: ingredient.percentFat, percentCarbs: ingredient.percentCarbs)
        let ingredientNutrition = IngredientNutrition(nutrients: ingredientNutrients, caloricBreakdown: ingredientCaloricBreakdown, weightPerServing: ingredientWeightPerServing)
        let ingredientID = IngredientID(id: Int(ingredient.id), image: ingredient.image!, name: ingredient.name!, originalName: ingredient.originalName!, aisle: ingredient.aisle!, consistency: ingredient.consistency!, nutrition: ingredientNutrition)
        return ingredientID
    }*/
    /*
    func convertRecipeCoreData(_ recipe: RecipeEntity) -> RecipeDetail {
        //var recipe: RecipeEntity
        let ingredients = managerRecipe.fetchRecipeIngredients(recipe: recipe)
        var extendedIngredients = [RecipeIngredient]()
        ingredients.forEach { ingredient in
            let us = Metric(amount: ingredient.measuresUSAmount, unitShort: ingredient.measuresUSUnitShort!, unitLong: ingredient.measuresUSUnitLong!)
            let metric = Metric(amount: ingredient.measuresMetricAmount, unitShort: ingredient.measuresMetricUnitShort!, unitLong: ingredient.measuresMetricUnitLong!)
            let measures = Measures(us: us, metric: metric)
            extendedIngredients.append(RecipeIngredient(id: Int(ingredient.id), image: ingredient.image, name: ingredient.name!, measures: measures))
        }
        
        
        let instructionsEntity = managerRecipe.fetchRecipeInstructions(recipe: recipe)
        var steps = [Step]()
        instructionsEntity.forEach { instruction in
            let length = Length(number: Int(instruction.lengthNumber), unit: instruction.lengthUnit ?? "")
            steps.append(Step(number: Int(instruction.number), step: instruction.step!, length: length))
        }
        let instructions: [RecipeInstructions] = [RecipeInstructions(steps: steps)]
        
        
        let nutritionEntity = managerRecipe.fetchRecipeNutrition(recipe: recipe)
        //print(nutritionEntity.count)
        //let nutritionEntityFirst = nutritionEntity.first!
        
        let nutrients = managerRecipe.fetchRecipeNutritionFlavonoid(nutrition: nutritionEntity)
        var flavonoids = [Flavonoid]()
        nutrients.forEach { nutrient in
            flavonoids.append(Flavonoid(name: nutrient.name!, amount: nutrient.amount, unit: nutrient.unit!, percentOfDailyNeeds: nutrient.percentOfDailyNeeds))
        }
        let units = Units(amount: Int(nutritionEntity.weightPerServingAmount), unit: nutritionEntity.weightPerServingUnit!)
        
        let nutrition = RecipeNutrition(nutrients: flavonoids, weightPerServing: units)
        let recipeDetail = RecipeDetail(isVegetarian: recipe.isVegetarian, likes: Int(recipe.likes), credits: recipe.credits!, id: Int(recipe.id), nameRecipe: recipe.nameRecipe!, minutes: Int(recipe.minutes), servings: Int(recipe.servings), extendedIngredients: extendedIngredients, nutrition: nutrition, instructions: instructions)
        return recipeDetail
    }
     */
    
}

//MARK: Extension para el Data Source de la tableView
extension AddFoodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch activeSearchType {
            //Dependiendo si se esta buscando ingredientes o recetas regresara un numero diferente
        case .ingredients:
            return ingredients.count
        case .recipes:
            return recipes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddFoodTVC", for: indexPath) as! AddFoodTableViewCell
        switch activeSearchType {
            //Dependiendo si se esta buscando ingredientes o recetas se regresara una celda diferente
        case .ingredients:
            let ingredient = ingredients[indexPath.row]
            cell.setUpFood(name: ingredient.name, unit: ingredient.units, amount: ingredient.amount)
            //Realizamos una solicitud de red para obtener una imagen del ingrediente
            let fetchIngredientImage = FetchIngredientImage(nameIngredient: ingredient.image)
            tableViewTasks[indexPath] = Task {
                if let image = try? await sendRequest(fetchIngredientImage),
                   let currentIndexPath = tableView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                    cell.foodImageView.image = image /***Actualiamos la imagen de la celda*/
                }
                tableViewTasks[indexPath] = nil /***Cancelamos la Task de la imagen */
            }
            return cell
        case .recipes:
            let recipe = recipes[indexPath.row]
            cell.setUpFood(name: recipe.name, unit: recipe.units, amount: recipe.amount)
            //Realizamos una solicitud de red para obtener una imagen de la receta
            let fetchRecipeImageID = FetchRecipeImageID(id: String(recipe.id), type: recipe.image)
            tableViewTasks[indexPath] = Task {
                if let image = try? await sendRequest(fetchRecipeImageID),
                   let currentIndexPath = tableView.indexPath(for: cell),
                   currentIndexPath == indexPath {
                    cell.foodImageView.image = image /***Actualiamos la imagen de la celda*/
                }
                tableViewTasks[indexPath] = nil /***Cancelamos la Task de la imagen */
            }
            return cell
        }
    }
    
    // Establecemos la altura de a celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    //MARK: Metodos para eliminar una celda
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch activeSearchType {
                //Eliminamos la celda dependiendo si esta activo los ingredientes o recetas
            case .ingredients:
                removeIngredientCoreData(row: indexPath.row) /***Eliminamos el ingrediente de CoreData */
                ingredients.remove(at: indexPath.row)
            case .recipes:
                removeRecipeCoreData(row: indexPath.row) /***Eliminamos la receta de CoreData */
                recipes.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            editFoodButton()
        }
    }
    
    // En caso de que el ingrediente ya estaba agregado en CoreData lo eliminamos
    func removeIngredientCoreData (row: Int) {
        allIngredients.forEach { ingredient in
            //Buscamos si el ingrediente esta en la lista de ingredientes de CoreData y si esta lo eliminamos
            if ingredient.idU == ingredientEntity?.idU {
                managerIngredient.deleteIngredient(ingredient)
            }
        }
    }
    // En caso de que la receta ya estaba agregada en CoreData lo eliminamos
    func removeRecipeCoreData (row: Int) {
        allRecipes.forEach { recipe in
            //Buscamos si la receta esta en la lista de recetas de CoreData y si esta la eliminamos
            if recipe.idU == recipeEntity?.idU {
                managerRecipe.deleteRecipe(recipe)
            }
        }
    }
}

//MARK: Extension para el Delegado de la tableView
extension AddFoodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch activeSearchType {
            //Se redirige a una nueva vista con la informacion del ingrediente o receta que se seleciono
        case .ingredients :
            EditIngredientAmount(ingredient: ingredients[indexPath.row], row: indexPath.row)
        case .recipes :
            EditRecipePortions(recipe: recipes[indexPath.row], row: indexPath.row)
        }
    }
    //Metodo para ir a una vista para editar las porciones de una receta
    func EditRecipePortions(recipe:  Food, row: Int ){
        // instanciamos una vista para presentarla
        let editRecipePortionsStoryboard = UIStoryboard(name: "EditRecipePortions", bundle: .main)
        //Instanciamos un EditRecipePortionsViewController
        if let editRecipePortionsViewController = editRecipePortionsStoryboard.instantiateViewController(withIdentifier: "EditRecipePortionsVC") as? EditRecipePortionsViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            editRecipePortionsViewController.recipeFood = recipe /***Pasamos la receta*/
            editRecipePortionsViewController.delegate = self
            editRecipePortionsViewController.row = row
            present(editRecipePortionsViewController, animated: true)
        }
    }
    
    //Metodo para ir a una vista para editar los gr de un ingrediente
    func EditIngredientAmount(ingredient: Food, row: Int) {
        // instanciamos una vista para presentarla
        let editIngredientAmountStoryboard = UIStoryboard(name: "EditIngredientAmount", bundle: .main)
        //Instanciamos un EditIngredientAmountViewController
        if let editIngredientAmountViewController = editIngredientAmountStoryboard.instantiateViewController(withIdentifier: "EditIngredientAmountVC") as? EditIngredientAmountViewController {
            editIngredientAmountViewController.ingredientFood = ingredient
            editIngredientAmountViewController.delegate = self
            editIngredientAmountViewController.row = row
            // realizamos la presentacion de tipo push para la siguiente vista
            present(editIngredientAmountViewController, animated: true)
            //navigationController?.pushViewController(recipeListByCategoryFilterViewController, animated: true)
        }
    }
}

//MARK: Extension para el protocolo de UISearchResultsUpdating
extension AddFoodViewController: UISearchResultsUpdating, UISearchBarDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        //obtenemos el string de la palabra que se busque
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else {
            return
        }
        //Configuramos algunos valores de FoodSearchListViewController para el UISearch
        let foodSearchListViewController = searchController.searchResultsController as? FoodSearchListViewController
        foodSearchListViewController?.areLookingIngredients = activeSearchType == .ingredients ? true : false
        foodSearchListViewController?.delegate = self
        //Dependiendo que se este buscando se realizara una peticon de red
        switch activeSearchType {
        case .ingredients:
            foodSearchListViewController?.searchForIngredients(word: searchString)/***Mandamos la palabra al metodo para hacer la busqueda de los ingredientes y mostrarlos en la tableView*/
        case .recipes:
            foodSearchListViewController?.searchForRecipes(word: searchString)/***Mandamos la palabra al metodopara hacer la busqueda de las recetas y mostrarlos en la tableView*/
        }
    }
}

//MARK: Delegado de FoodSearchListViewController
extension AddFoodViewController: FoodSearchListViewControllerDelegate{
    //Cuando se presione un ingrediente, este pasara a esta vista
    func ingredientSearchListViewController(_ controller: FoodSearchListViewController, food: Food) {
        ingredients.append(food)/***Agregamos el ingrediente a la lista de esta vista*/
        updateChangesInViews()
    }
    //Cuando se presione una receta, esta pasara a esta vista
    func recipeSearchListViewController(_ controller: FoodSearchListViewController, food: Food) {
        recipes.append(food) /***Agregamos la receta a la lista de esta vista*/
        updateChangesInViews()
    }
    
    func updateChangesInViews(){
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.text = ""
        editFoodButton()
        tableView.reloadData()/***Mostramos la nueva receta o ingrediente agregado*/
    }
}

//MARK: Delegado de la vista para editar un ingrediente
extension AddFoodViewController: EditIngredientAmountViewControllerDelegate {
    //Pasamos la nueva cantidad de gr a esta vista
    func editIngredientAmountViewController(_ controller: EditIngredientAmountViewController, newAmount: Int, row: Int) {
        ingredients[row].amount = Double(newAmount)
        tableView.reloadData()
    }
}

//MARK: Delegado de la vista para editar una receta
extension AddFoodViewController: EditRecipePortionsViewControllerDelegate {
    //Pasamos la nueva cantidad de porciones a esta vista
    func editRecipePortionsViewController(_ controller: EditRecipePortionsViewController, newAmount: Int, row: Int) {
        recipes[row].amount = Double(newAmount)
        tableView.reloadData()
    }
}
