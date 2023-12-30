//
//  IngredientSearchListToToolsPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 29/09/23.
//
//MARK: INFO:
/*Vista para poder presentar diferentes ingredientes buscados por una palabra*/

import UIKit

class IngredientSearchListToToolsPageViewController: UIViewController {

    //MARK: Inicializaciones generles
    var tableView = UITableView()
    var ingredients: AutocompleteWordIngredientsToToolsPage! /***Lista de los ingredientes para la tableView*/
    var tableViewTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    weak var delegate: IngredientSearchListToToolsPageViewControllerDelegate? /***Delegado para poder pasar a la vista del ingrediente*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView() /***Cofiguramos su posicion, delegado, dataSource y su celda*/
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tableViewTasks.forEach {key, value in value.cancel() } /***Concelamos las tareas en caso de que no se requiran cuando nos pasamos a otra vista*/
    }

    func configureTableView() {
        view.addSubview(tableView) /***Agregamos la tableView a la vista del viewController*/
        //Asignamos el delegado y e dataSorce de tableView
        tableView.delegate = self
        tableView.dataSource = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "SearchIngredientToToolsPageForTableViewCell", bundle: .main), forCellReuseIdentifier: "SearchIngredientToToolsPageForTVC")
        tableView.pin(to: view) /***Registramos el lugar de la table View en la vista del viewController*/
    }
    
    //MARK: Buscar ingredientes con una palabra incompleta o completa
    func lookForIngredients(word: String){
        let autocompleteIngredientWord = AutocompleteIngredientWordToToolsPage(query: word)
        Task {
            do {
                /*Obtenemos la lista de los ingredientes a partir de una palabra incompleta*/
                let ingredients = try await sendRequest(autocompleteIngredientWord)
                self.ingredients = ingredients /***Lista de los ingredientes*/
                tableView.reloadData()
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }
}

//MARK: Extension para la DataSource del tableView
extension IngredientSearchListToToolsPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = ingredients == nil ? 0 : ingredients.count /***En caso de que aun no existan ingredientes*/
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchIngredientToToolsPageForTVC", for: indexPath) as! SearchIngredientToToolsPageForTableViewCell
        let ingredient = ingredients[indexPath.row]
        cell.setUpIngredient(name: ingredient.name, aisle: ingredient.aisle ?? "")
        
        let fetchIngredienOrEquipmentImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: ingredient.image, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
        tableViewTasks[indexPath] = Task { /*Tarea para obtener la imagen de un ingrediente*/
            /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
             Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
             */
            if let image = try? await sendRequest(fetchIngredienOrEquipmentImage),
               let currentIndexPath = tableView.indexPath(for: cell),
               currentIndexPath == indexPath {
                cell.ingredientImageView.image = image /***Actualiamos la imagen de la celda*/
            }
            tableViewTasks[indexPath] = nil /***Cancelamos la Task de la imagen */
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
}
//MARK: Extension para el Delegate del tableView
extension IngredientSearchListToToolsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = ingredients[indexPath.row]
        let name = ingredient.name
        let units = ingredient.possibleUnits
        let image = ingredient.image
        let id = ingredient.id
        delegate?.ingredientSearchListToToolsPageViewController(self, possibleUnits: units, name: name, image: image, id: id) /***metodo para poder pasar informacion del id y del name del ingrediente  a la vista anterior y poder pasar a la vista de detalle del ingrediente*/
        dismiss(animated: true)
    }
    
    //En caso de que se haya terminado de mostrar la celda con el ingrediente o la receta con su respectiva imagen
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewTasks[indexPath]?.cancel() /***Cancelamos la tarea de obtencion de la imagen en caso de que no se requiera */
    }
    
}

//MARK: Delegado para pasar informacion de esta vista a la anterior
protocol IngredientSearchListToToolsPageViewControllerDelegate: AnyObject {
    /*metodo para poder pasar informacion a la vista anterior y poder pasar a la vista de detalle del ingrediente*/
    func ingredientSearchListToToolsPageViewController(_ controller: IngredientSearchListToToolsPageViewController, possibleUnits: [String]?, name: String, image: String, id: Int)
}
