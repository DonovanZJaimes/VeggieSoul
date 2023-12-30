//
//  FoodSearchListViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 06/11/23.
//
//MARK: INFO:
/*Vista para poder presentar una tableView donde se mostraran las recetas o ingredientes que se busquen en el UISearchController de la vista anterior*/

import UIKit

class FoodSearchListViewController: UIViewController {

    //MARK: Inicializaciones generles
    var tableView = UITableView()
    var ingredients: AutocompleteNewIngredients! /***Lista de los ingredientes para la tableView*/
    var recipes: AutocompleteNewRecipes! /***Lista de las recetas para la tableView*/
    var tableViewTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    weak var delegate: FoodSearchListViewControllerDelegate? /***Delegado para poder pasar informacion de la comida seleccionada*/
    var areLookingIngredients: Bool!
    let starterIngredient = Ingredient(id: 9266, imagePNG: "pineapple.jpg", name: "pineapples")/***En caso de que la primera receta en pantalla no tenga ingredientes se pondra ese en la primera fila, esto para que la primera seccion no se quede vacia */
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() /***Agregamos la tableView a la vista ademas de asignar se delegado y dataSource*/
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableViewTasks.forEach {key, value in value.cancel() } /***Concelamos las tareas en caso de que no se requiran cuando nos pasamos a otra vista*/
    }
    
    //MARK: Configuramos la table view
    func configureTableView() {
        view.addSubview(tableView) /***Agregamos la tableView a la vista del viewController*/
        //Asignamos el delegado y e dataSorce de tableView
        tableView.delegate = self
        tableView.dataSource = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "SearchFoodTableViewCell", bundle: .main), forCellReuseIdentifier: "SearchFoodTVC")
        tableView.pin(to: view) /***Registramos el lugar de la table View en la vista del viewController*/
        
    }
    
    //MARK: Buscar ingredientes con una palabra incompleta o completa
    func searchForIngredients(word: String){
        //borramos la lista de las recetas actuales en la tableView
        if recipes != nil {
            self.recipes.removeAll()
        }
        // buscamos los nuevos ingredientes con la nueva parabra
        let autocompleteIngredientSearch = AutocompleteIngredientSearch(query: word)
        Task {
            do {
                /*Obtenemos la lista de los ingredientes a partir de una palabra incompleta*/
                let ingredients = try await sendRequest(autocompleteIngredientSearch)
                self.ingredients = ingredients /***Lista de los ingredientes*/
                tableView.reloadData()
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }

    //MARK: Buscar recetas con una palabra incompleta o completa
    func searchForRecipes(word: String){
        //borramos la lista de los ingredientes actuales en la tableView
        if ingredients != nil {
            self.ingredients.removeAll()
        }
        // buscamos las nuevas recetas con la nueva parabra
        let autocompleteRecipeSearch = AutocompleteRecipeSearch(query: word)
        Task {
            do {
                /*Obtenemos la lista de los ingredientes a partir de una palabra incompleta*/
                let recipes = try await sendRequest(autocompleteRecipeSearch)
                self.recipes = recipes /***Lista de los ingredientes*/
                tableView.reloadData()
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }
    

}

//MARK: Extension para el delegado de TableView
extension FoodSearchListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Verificar si se esta buscando en recetas o ingredientes
        switch areLookingIngredients {
        case true:
            let num = ingredients == nil ? 0 : ingredients.count /***En caso de que aun no existan ingredientes*/
            return num
        case false:
            let num = recipes == nil ? 0 : recipes.count /***En caso de que aun no existan recetas*/
            return num
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchFoodTVC", for: indexPath) as! SearchFoodTableViewCell
        cell.accessoryType = .disclosureIndicator
        //Verificar si se esta buscando en recetas o ingredientes
        guard areLookingIngredients == true else {
            //En caso de estar buscando recetas:
            let recipe = recipes[indexPath.row]
            cell.nameFoodLabel.text = recipe.title
            //realizar una peticion a la red para obtener la imagen de la receta
            let fetchRecipeImageID = FetchRecipeImageID(id: String(recipe.id), type: recipe.imageType)
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
        //En caso de estar buscando ingredientes:
        let ingredient = ingredients[indexPath.row]
        cell.nameFoodLabel.text = ingredient.name
        let imagePNG = ingredient.image ?? self.starterIngredient.imagePNG /***En caso de que el ingrediente no tenga imagen*/
        //realizar una peticion a la red para obtener la imagen del ingrediente
        let fetchIngredientImage = FetchIngredientImage(nameIngredient: imagePNG!)
        tableViewTasks[indexPath] = Task {
            if let image = try? await sendRequest(fetchIngredientImage),
               let currentIndexPath = tableView.indexPath(for: cell),
               currentIndexPath == indexPath {
                cell.foodImageView.image = image /***Actualiamos la imagen de la celda*/
            }
            
            tableViewTasks[indexPath] = nil /***Cancelamos la Task de la imagen */
        }
        return cell
    }
}

//MARK: Extension para el delegado para la Table View
extension FoodSearchListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Verificar si se esta presionando una recetas o ingrediente
        guard  areLookingIngredients == true else {
            //En caso de seleccionar una receta:
            let recipe = recipes[indexPath.row]
            let food = Food(name: recipe.title, id: recipe.id, image: recipe.imageType, units: "portions", amount: 1)
            delegate?.recipeSearchListViewController(self, food: food) /***Pasamos la informacion de la receta a la vista anterior*/
            dismiss(animated: true)
            return
            
        }
        //En caso de seleccionar un ingrediente:
        let ingredient = ingredients[indexPath.row]
        let imagePNG = ingredient.image ?? self.starterIngredient.imagePNG
        let food = Food(name: ingredient.name, id: ingredient.id, image: imagePNG!, units: "g", amount: 100)
        delegate?.ingredientSearchListViewController(self, food: food) /***Pasamos la informacion del ingrediente a la vista anterior*/
        dismiss(animated: true)
    }
    
    //En caso de que se haya terminado de mostrar la celda con el ingrediente o la receta con su respectiva imagen
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewTasks[indexPath]?.cancel() /***Cancelamos la tarea de obtencion de la imagen en caso de que no se requiera */
    }
}

//MARK: Delegado para pasar informacion de esta vista a la anterior
protocol FoodSearchListViewControllerDelegate: AnyObject {
    /*Funcion para poder pasar informacion a la vista anterior y poder pasar a la vista de detalle del ingrediente*/
    func ingredientSearchListViewController(_ controller: FoodSearchListViewController, food: Food)
    /*Funcion para poder pasar informacion a la vista anterior y poder pasar a la vista de detalle de la receta*/
    func recipeSearchListViewController(_ controller: FoodSearchListViewController, food: Food)
}
