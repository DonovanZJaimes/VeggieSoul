//
//  RecipeListByCategoryViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 15/07/23.
//
//MARK: INFO:
/*Vista para poder presentar diferentes recetas  de un tipo decategoria que se solicito en la vista "RecipeHome"*/

import UIKit

class RecipeListByCategoryViewController: UIViewController {
    
    //MARK: Definrir secciones
    enum Section: Hashable {
        case recipes
    }
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var tableView: UITableView!
    
    
    //MARK: Inicializaciones generales
    var category: String! /***Contiene el nombre de la categoria que se seleccinaron en la vista anterior "RecipeHome"*/
    var diet = "vegetarian" /***Tipo de dieta para la solicitud de red*/
    //: [String] = ["vegetarian"] /***Valores de las dietas que queramos que sean las recetas*/
    var meals = [String]()/***Lista de tipo de comidas para realizar la solicitud de red*/
    let backgroundRecipeImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la reeta no tenga imagen, se colocara esta*/
    var recipesByCategory = [RecipeByCategory]() /***Propiedad que contendra las recetas y servira par proporcionar inforacion al tadatsource***/
    var dataSource: UITableViewDiffableDataSource<Section,RecipeByCategory>!  /***Creara una variable abierta implícitamente para la fuente de datos que usa el tipo de sección que acaba de definir para las secciones que se mostraran en pantalla y el tipo de items que estaran dentro ***/
    var tableViewImageTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        let stringCategory = formattedString(category: category)/***Obtenemos un string adecauado para poder realizar una solicitud de red*/
        meals.append(stringCategory)
        requestRecipesByCategory(diet, meals: meals, intolerances: nil)/***Metodo para realizar una solicitud de red para poder recibir recetas con el tipo de categoria*/
        setUpTableView() /***Actualizamos el tableView como su tableViewLayout, celdas, y delegado*/
        configureTableViewDataSource () /***Configuramos el estilo de dataSourse por ocupar UITableViewDiffableDataSource*/
        configureNavigationItem () /***Configurar el el titulo y el boton de navigationItem***/
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableViewImageTasks.forEach {key, value in value.cancel()} /***Borramos todas las  task de imagenes cuando nos salgamos de esta vista*/
    }

    
    //MARK: Formatear el nombre de la categoria
    func formattedString (category: String) -> String {
        let stringCategory = category.lowercased().replacingOccurrences(of: " ", with: "_")  /***Si en el nombre de la categoria existe un espacio esta linea lo susuituye por un  "_" y pone toddo en minusculas*/
        return stringCategory
    }
    
    //MARK: Solicitud de red para obtener recetas por el tipo de categoria
    //Esto metodo tambien se llama en caso que los parametros cambien
    func requestRecipesByCategory (_ diet: String, meals: [String], intolerances: [String]?){
        let recepiByTypeAndTags = RecepiByTypeAndTags(diet: diet, meals: meals, intolerances: intolerances) /***Se instancia un objeto que contiene la informacion del tipo de categoria, el tipo de dieta y las intoleracias que no queremos tener en nuestras recetas l*/
        Task.init{
            do {
                let recipesByCategory = try await sendRequest(recepiByTypeAndTags) /***Solicitamos las recetas */
                self.recipesByCategory = recipesByCategory.recipes /***Se agregan las recetas obtenidas al arreglo que se instancio al inicio de este controlador***/
                //print(recipesByCategory)
                await self.dataSource.apply(self.tableSnapshot, animatingDifferences: true) /***Se recarga la vista de dataSource*/
            }catch{
                print (error)
            }
        }
    }
    //MARK: Registar las celdas ocupadas y el delegado de tabelView
    func setUpTableView() {
        //Asignamos el delegado de tableView
        tableView.delegate = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "ListRecipeDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "ListRecipeDetailTVC")
    }
   
    
    
    //MARK: Establecer Data Source de tableView
    func configureTableViewDataSource (){
        dataSource = UITableViewDiffableDataSource<Section,RecipeByCategory> (tableView: tableView, cellProvider: {
            (tableView, indexPath, item) -> UITableViewCell  in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ListRecipeDetailTVC", for: indexPath) as! ListRecipeDetailTableViewCell /***Se obtiene la celda para presentar la informacion obtenida*/
            cell.setUpRecipeByCategory(item) /***Se usa el metodo setUpRecipeByCategory para poder enviar la informacion a la celda y presentarlo */
            let fetchRecipeImage = FetchRecipeImage(url: item.image ?? self.backgroundRecipeImageURL) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de la receta*/
            self.tableViewImageTasks[indexPath] =  Task.init {  /***Creamos una Tak y la gregamos al arreglo para despues borrarla*/
                /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                 Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en tableView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                 */
                if let image = try? await sendRequest(fetchRecipeImage) {
                    if let currentIndexPath = self.tableView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        //Se agrega la imagen a la celda
                        cell.recipeImage.image = image
                    }
                    
                }
                self.tableViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
            }
            return cell
        })
        dataSource.apply(tableSnapshot) /***Aparecer la informacion de las celdas al iniciar la vista***/
    }
    
    
    //MARK: Creaccion del SnapShot para la seccion de recetas
    var tableSnapshot: NSDiffableDataSourceSnapshot<Section,RecipeByCategory> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,RecipeByCategory>()/***SnapShot vacio*/
        //Instancias la unica sccion de esta vista
        snapshot.appendSections([Section.recipes])/***Esta seccion se encuentar arriba de este controlador*/
        snapshot.appendItems(recipesByCategory)/***recipesByCategory se instancia al inicio y contiene la informacion de las recetas cuando se llamo al metodo requestRecipesByCategory */
        return snapshot
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = category
       
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(editFilter))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Recipes", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Editar los filtros
    @objc func editFilter(){
        print("aplicar filtros")
        // instanciamos una vista para presentarla
        let recipeListByCategoryFilterStoryboard = UIStoryboard(name: "RecipeListByCategoryFilter", bundle: .main)
        //Instanciamos un RecipeListByCategoryFilterViewController
        if let recipeListByCategoryFilterViewController = recipeListByCategoryFilterStoryboard.instantiateViewController(withIdentifier: "RecipeListByCategoryFilterVC") as? RecipeListByCategoryFilterViewController {
            VariablesFilterRecipes.shared.typeOfMealToFilterRecipes = category
            // realizamos la presentacion de tipo push para la siguiente vista
            recipeListByCategoryFilterViewController.delegate = self
            present(recipeListByCategoryFilterViewController, animated: true)
            //navigationController?.pushViewController(recipeListByCategoryFilterViewController, animated: true)
        }
    }
 
}


//MARK: Extension para determinar el delegado de tableView
extension RecipeListByCategoryViewController: UITableViewDelegate{
    
    //MARK: Declarar la altura de cada celda
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(280)/***Establecemos una altura para cada celda*/
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = CGFloat(280) /***Establecemos una altura para cada celda*/
        return height
    }
    
    //MARK: Borrar la Task de la imagen de la celda que se removio
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewImageTasks[indexPath]?.cancel()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // instanciamos una vista para presentarla
        let recipeDetail = UIStoryboard(name: "RecipeDetail", bundle: .main)
        //Instanciamos un RecipeDetailViewController
        if let recipeDetailViewController = recipeDetail.instantiateViewController(withIdentifier: "RecipeDetailVC") as? RecipeDetailViewController {
            //recipeDetailViewController.namee = "pasamos"
            recipeDetailViewController.id = recipesByCategory[indexPath.row].id
            //RecipeItem.recipesByIngredient[indexPath.row].recipeByIngredient?.id /***Enviamos el id de la receta para poder ver sus detalles en la siguiente vista***/
            //MARK: BORRAR
            recipeDetailViewController.name = recipesByCategory[indexPath.row].name
            //RecipeItem.recipesByIngredient[indexPath.row].recipeByIngredient?.name
            // realizamos la presentacion de tipo push para la siguiente vista
            self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
        }
    }
    
    
    
    
}

//MARK: Delegado para recibir informacion para filtrar las recetas
extension RecipeListByCategoryViewController: RecipeListByCategoryFilterViewControllerDelegate {
    func recipeListByCategoryFilterViewController(_ controller: RecipeListByCategoryFilterViewController, typeOfMealsSelected: [String], typeOfDietSelected: String) {
        /*Asignamos los valores de l funciona diet y meals que nos ayudaran a realizar la solicitud de red*/
        diet = typeOfDietSelected
        meals = typeOfMealsSelected
        requestRecipesByCategory(diet, meals: meals, intolerances: nil)/***Metodo para realizar una solicitud de red para poder recibir recetas con el tipo de categoria*/
        meals.removeAll()
        meals.append(category) /***Dejamos a meals como estaba la inicio*/
    }
    
    
}
