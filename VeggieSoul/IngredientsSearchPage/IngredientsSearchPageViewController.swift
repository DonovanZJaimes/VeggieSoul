//
//  IngredientsSearchPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 11/07/23.
//
//MARK: INFO:
/*Vista para poder presentar diferentes ingredientes junto con su  aisle y un apartado para buscar algun ingrediente*/

import UIKit

class IngredientsSearchPageViewController: UIViewController {
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var ingredientsTableView: UITableView!
    
    //MARK: Inicializaciones generles
    let searchController = UISearchController(searchResultsController: IngredientSearchListViewController())
    var ingredients = [IngredientSearchPage]() /***Lista de los ingredinetes para las celdas*/
    var tableViewTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomIngredients() /***Ingredientes para las celdas de la tableView***/
        setupSearchController() /***Actualizamos el search controller para poder hacer las busquedas*/
        setUpTitle () /***Configuramos el titulo al inicio de la vista***/
        setUpTableView()/***Actualizamos el tableView como su tableViewLayout, celdas, y delegado*/

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableViewTasks.forEach {key, value in value.cancel() } /***Concelamos las tareas en caso de que no se requiran cuando nos pasamos a otra vista*/
    }
    
   //MARK: Obtener los ingredientes para las celdas
    //metodo para obtener una lista de ingredinetes aleatorios
    func getRandomIngredients() {
        let totalRecipesWithIgredients = RecipeWithIngredientsAPI(type: "salad")
        var newIngredients = [IngredientSearchPage]()
        Task {
            do{
                /*Obtenemos la lista de los ingredientes a partir de una lista de recetas aleatorias*/
                let recipesWithIngredients = try await sendRequest(totalRecipesWithIgredients)
                for index in 0 ..< recipesWithIngredients.recipes.count {
                    for index2 in 0 ..< recipesWithIngredients.recipes[index].ingredients.count {
                        let ingredient = recipesWithIngredients.recipes[index].ingredients[index2]
                        newIngredients.append(ingredient) /***Lista de los ingredientes*/
                    }
                }
                ingredients = filterIngredients(newIngredients) /***filtra la lista de ingredinetes*/
                ingredientsTableView.reloadData()
                //print(ingredients)
            } catch{
                print(error)
            }
        }
    }
    
    //metodo que filtra una lista de ingredientes
    func filterIngredients(_ ingredients :[IngredientSearchPage]) -> [IngredientSearchPage] {
        /*Se obtienen solo los ingredientes con una imagen de tipo . png*/
        var ingredientsWithImagePGN = [IngredientSearchPage]()
        for index in 0 ..< ingredients.count{
            if ingredients[index].imagePNG!.contains(".png")  {
                ingredientsWithImagePGN.append(ingredients[index]) /***Lista de ingredientes con imagen .png***/
            }
        }
        /*Elimna los ingredientes repetidos de la lista anterior*/
        var filteredIngredients = [IngredientSearchPage]()
        var listIDs = [Int]()
        for index in 0 ..< ingredientsWithImagePGN.count {
            if !listIDs.contains(ingredientsWithImagePGN[index].id) {
                filteredIngredients.append(ingredientsWithImagePGN[index])/***Lista de ingredientes sin repeticion*/
                listIDs.append(ingredientsWithImagePGN[index].id) /***Lista de ID de los ingredinetes sin repeticion*/
            }
        }
        return filteredIngredients /***Lista de los ingredientes filtrados*/
    }
    
    
    //MARK: Actualizar el search Controller
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        navigationItem.title = "INGREDIENTS"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
    }
    
    
    //MARK: Registar las celdas ocupadas, el delegado y la DataSource de tabelView
    func setUpTableView() {
        //Asignamos el delegado y e dataSorce de tableView
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        //Se registra la celda a ocupar
        ingredientsTableView.register(UINib(nibName: "IngredientSearchPageTableViewCell", bundle: .main), forCellReuseIdentifier: "IngredientSearchPageTVC")
    }
    
    //MARK: Ir a la vista de detalle del ingrediente
    func goToIngredientDetailView(id: Int, name: String){
        // instanciamos una vista para presentarla
        let ingredientDetailStoryboard = UIStoryboard(name: "IngredientDetail", bundle: .main)
        //Instanciamos un RecipeListViewController
        if let ingredientDetailViewController = ingredientDetailStoryboard.instantiateViewController(withIdentifier: "IngredientDetailVC") as? IngredientDetailViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            ingredientDetailViewController.Id = id
            ingredientDetailViewController.name = name
            navigationController?.pushViewController(ingredientDetailViewController, animated: true)
        }
    }
  

}

//MARK: Extension para la DataSource del tableView
extension IngredientsSearchPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "IngredientSearchPageTVC", for: indexPath) as! IngredientSearchPageTableViewCell
        let ingredient = ingredients[indexPath.row]
        let name = ingredient.name
        let aisle = ingredient.aisle
        let stringImage = ingredient.imagePNG
        let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: stringImage!, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
        cell.setUpIngredient(name: name, aisle: "Aisle: " + aisle) /***Actualizamos los labels de la celda*/
        tableViewTasks[indexPath] = Task { /*Tarea para obtener la imagen de un ingrediente*/
            /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
             Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
             */
            if let image = try? await sendRequest(fetchIngredientImage),
               let currentIndexPath = ingredientsTableView.indexPath(for: cell),
               currentIndexPath == indexPath {
                cell.ingredientImageView.image = image /***Actualiamos la imagen de la celda*/
            }
            tableViewTasks[indexPath] = nil /***Cancelamos la Task de la imagen */
        }
        return cell
    }
    
    
}

//MARK: Extension para el Delegado de la tableView
extension IngredientsSearchPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = ingredients[indexPath.row]
        let id = ingredient.id
        goToIngredientDetailView(id: id, name: ingredient.name) /***Pasamos a la vista de detalle del ingrediente*/
    }
    
    //En caso de que se haya terminado de mostrar la celda con el ingrediente o la receta con su respectiva imagen
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewTasks[indexPath]?.cancel() /***Cancelamos la tarea de obtencion de la imagen en caso de que no se requiera */
    }
}


//MARK: Extension para el protocolo de UISearchResultsUpdating
extension IngredientsSearchPageViewController: UISearchResultsUpdating, UISearchBarDelegate  {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else {
            return
        }
        let ingredientSearchListViewController = searchController.searchResultsController as? IngredientSearchListViewController
        ingredientSearchListViewController?.delegate = self
        ingredientSearchListViewController?.lookForIngredients(word: searchString)/***Mandamos la palabra al metodo para hacer la busqueda de los ingredientes y mostrarlos en la tableView*/
    }
    
    
}

extension IngredientsSearchPageViewController: IngredientSearchListViewControllerDelegate{
    func ingredientSearchListViewController(_ controller: IngredientSearchListViewController, id: Int, name: String) {
        searchController.searchBar.resignFirstResponder()
        goToIngredientDetailView(id: id, name: name) /***Pasamos a la vista de detalle del ingrediente con informacion enviada de la vista  IngredientSearchList*/
    }
}
