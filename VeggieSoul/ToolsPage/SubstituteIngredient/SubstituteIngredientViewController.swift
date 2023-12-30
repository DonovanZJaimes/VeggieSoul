//
//  SubstituteIngredientViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 24/09/23.
//
//MARK: INFO:
/*Se presentan los posibles sustitutos de un ingrediete seleccionado*/

import UIKit

class SubstituteIngredientViewController: UIViewController {
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var nameIngredientLabel: UILabel!
    @IBOutlet var ingredientImageView: UIImageView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    //MARK: Inicializaciones generales
    let searchController = UISearchController(searchResultsController: IngredientSearchListToToolsPageViewController())
    var substitutes = ["1 cup = 7/8 cup shortening and 1/2 tsp salt", "1 cup = 7/8 cup vegetable oil + 1/2 tsp salt", "1/2 cup = 1/4 cup buttermilk + 1/4 cup unsweetened applesauce", "1 cup = 1 cup margarine"] /***Valores para las celdas del tableView*/
    var image = "butter.jpg"
    var nameIngredient = "butter"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        updateIngredient(name: nameIngredient, image: self.image, message: "Found 4 substitutes for the ingredient") /***Configuramos los valores de la vista*/
        setUpSearchController() /***Actualizamos el search controller para poder hacer las busquedas*/
        setUpNavigationItem () /***Configuramos el titulo al inicio de la vista*/
        updateImage() /***Configurar el estilo de la imagen*/
        
    }
    
    //MARK: Asignar delegado y dataSource a la tableView
    func configureTableView() {
        //Asignamos el delegado y e dataSorce de tableView
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //MARK: Actualizamos la vista con la informacion del ingrediente
    func updateIngredient(name: String, image: String, message: String) {
        //Configuramos el nombre, imagen y mensaje
        nameIngredientLabel.text = name
        requestImageIngredient(imageURl: image)
        messageLabel.text = message
    }
    
    //Solicitamos la imagen del ingrediente
    func requestImageIngredient(imageURl: String) {
        let fetchIngredienOrEquipmentImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: imageURl, isIngredient: true)
        Task {
            /*Solicitamos la imagen del ingrediente a la API*/
            if let image = try? await sendRequest(fetchIngredienOrEquipmentImage){
                ingredientImageView.image = image /***Agregamos la imagen obtenida a la imageView*/
            }
        }
    }
    
    //MARK: Actualizar el search Controller
    func setUpSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Ingredients"
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpNavigationItem (){
        //Titulo
        navigationItem.title = "Ingredient Substitutes"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Tools", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Configurar el estilo de la imagen
    func updateImage() {
        // Hacemos que la imagen del ingrediente tenga un redondeo en los bordes
        ingredientImageView.layer.cornerRadius = ingredientImageView.frame.width / 2
    }
    
    //MARK: Solicitud a la API para solicitar sustitutos del ingrediente
    func requestSubstituteIngredient(id: Int){
        let getIngredientSubstitutesByID = GetIngredientSubstitutesByID(id: id)
        Task{
            do {
                let substituteIngredient = try await sendRequest(getIngredientSubstitutesByID) /***Realizamos una solicitud a la API con el id */
                //Configuramos la vista con la informacion nueva del ingrediente
                let name = substituteIngredient.ingredient ?? nameIngredient
                let message = substituteIngredient.message
                updateIngredient(name: name, image: self.image, message: message)
                //Configuramos los nuevos datos de la tableView
                self.substitutes = substituteIngredient.substitutes ?? [] /***Nuevos valores de las celdas*/
                tableView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    

}

//MARK: Extension para el protocolo de UISearchResultsUpdating
extension SubstituteIngredientViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //verificamos si existe algun texto o si se esta modificado
        guard let searchString = searchController.searchBar.text,
              searchString.isEmpty == false else {
            return
        }
        let ingredientSearchListToToolsPageViewController = searchController.searchResultsController as? IngredientSearchListToToolsPageViewController
        ingredientSearchListToToolsPageViewController?.delegate = self
        ingredientSearchListToToolsPageViewController?.lookForIngredients(word: searchString)/***Mandamos la palabra al metodo para hacer la busqueda de los ingredientes y mostrarlos en la tableView*/
    }
}

//MARK: Extension para el delegado de IngredientSearchListToToolsPageViewController
extension SubstituteIngredientViewController: IngredientSearchListToToolsPageViewControllerDelegate {
    func ingredientSearchListToToolsPageViewController(_ controller: IngredientSearchListToToolsPageViewController, possibleUnits: [String]?, name: String, image: String, id: Int) {
        self.image = image
        self.nameIngredient = name
        requestSubstituteIngredient(id: id) /***Solicitud a la API para solicitar sustitutos del ingrediente*/
        
    }
    
    
}

//MARK: Extension para el delegado y dataSource del tableView
extension SubstituteIngredientViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        substitutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubstituteIngredientTVC", for: indexPath)
        let substitute = substitutes[indexPath.row] /***Obtenemos los valores para la celda*/
        //Configuramos los nuevos valores a la celda
        var content = cell.defaultContentConfiguration()
        content.text = substitute
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Substitutes"
    }
    
}
