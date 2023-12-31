//
//  RecipeListViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 08/07/23.
//
//MARK: INFO:
/*Vista para poder presentar diferentes recetas  con los ingredientes seleccionados anterioemente en al vista de "RecipeSearchList"*/

import UIKit

class RecipeListByIngredientViewController: UIViewController {
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var collectionView: UICollectionView!
    
    //MARK: Definir vistas suplementarias
    enum SupplementaryViewKind {
        static let topLine = "topLine"
    }
    
    
    //MARK: Definrir secciones
    enum Section: Hashable {
        case recipes
        case ingredients
    }
    
    //MARK: Inicializaciones generales
    var nameOfIngredients: [String]! /***Contiene el nombre de los ingredientes que se seleccinaron en la vista anterior "RecipeSearchList"*/
    var imageOfIngredients: [String]!/***Contiene el nombre de las imagenes de los ingredientes que se seleccinaron en la vista anterior "RecipeSearchList"*/
    let backgroundRecipeImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la reeta no tenga imagen, se colocara esta*/
    var sections = [Section]()/***Arreglo de la enumeracion Section que esta arriba***/
    var dataSource: UICollectionViewDiffableDataSource<Section,RecipeItem>! /***Creara una variable abierta implícitamente para la fuente de datos que usa el tipo de sección que acaba de definir para las secciones que se mostraran en pantalla y el tipo de items que estaran dentro ***/
    var collectionViewImageTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    var ranking: Int = 2 /***Valor para hacer la solicitud de red*/
    var ignorePantry: Bool = false /***Valor para hacer la solicitud de red*/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpIngredients () /***Se actualiza los items de la primera seccion del data source que es de los ingredientes ***/
        let stringIngredients = formattedString(ingredients: nameOfIngredients)/***Obtenemos el string adecuado de los ingredientes para poder realizar una solicitud de red*/
        requestRecipesByIngredient(ingredients: stringIngredients)/***Metodo para realizar una solicitud de red para poder recibir recetas con los ingredientes seleccionados*/
        setUpCollectionView() /***Actualizamos el collectionView como su collectionViewLayout, celdas, y delegado*/
        configureDataSource () /***Configuramos el estilo de dataSourse por ocupar UICollectionViewDiffableDataSource*/
        //print(imageOfIngredients)
        configureNavigationItem ()/***Configura el titulo y los botones del navigation bar */
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        collectionViewImageTasks.forEach {key, value in value.cancel()} /***Borramos todas las  task de imagenes cuando nos salgamos de esta vista*/
    }
    
    
    //MARK: Metodo para acompletar RecipeItem.ingredientsForRecipeSearch
    //Esto metodo tambien se llama en caso que los ingredientes sean modificados
    func setUpIngredients () {
        /*Primero se creara una arreglo de tipo IngredientRecipeList para despues realizar un ciclo for para llenar este arreglo con las variables de imageOfIngredients y nameOfIngredients que se instanciaron al inicio de este controlador*/
        var ingredientsForRecipes = [IngredientRecipeList]()
        let nIngredients = nameOfIngredients.count - 1 /***Contamos el numero actual de ingredientes para buscar recetas*/
        for index in 0...nIngredients{
            ingredientsForRecipes.append(IngredientRecipeList(imagePNG: imageOfIngredients[index], name: nameOfIngredients[index]))
        }
        RecipeItem.ingredientsForRecipeSearch = ingredientsForRecipes.map {RecipeItem.ingredientRecipeList($0)} /***Pasamos el erreglo anteriormente creado y agregamos susu valores a la propiedad  ingredientsForRecipeSearch la cual es parte de los items del data source*/
        //print(RecipeItem.ingredientsForRecipeSearch)
    }
    
    //MARK: Formatear los nombres de los ingredientes
    //Esto metodo tambien se llama en caso que los ingredientes sean modificados
    func formattedString (ingredients: [String]) -> String {
        var stringIngredients = ingredients.joined(separator: ",+") /***Para el arreglo que se envia se junta a un solo string con separadores ",+"***/
        stringIngredients = stringIngredients.lowercased().replacingOccurrences(of: " ", with: "_") /***Si en el string anterior existe un espacio esta linea lo susuituye por un  "_"*/
        return stringIngredients /***Regresamos el string***/
    }
    
    //MARK: Solicitud de red para obtener recetas por los ingredientes selecionados
    //Esto metodo tambien se llama en caso que los ingredientes sean modificados y se requiera cambiar las recetas
    func requestRecipesByIngredient (ingredients: String){
        let recepiByIngredients = RecipeByIngredents(ingredients: ingredients, ranking: ranking, ignorePantry: ignorePantry) /***Se instancia un objeto que contiene la informacion de los difenetes ingredientes para solicitar recetas***/
        Task.init{
            do {
                let recipesByIngredient = try await sendRequest(recepiByIngredients)/***Solicitamos las recetas */
                RecipeItem.recipesByIngredient = recipesByIngredient.map {RecipeItem.recipeByIngredient($0)} /***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura RecipeItem y se lo agregamos a su respectivo arreglo*/
                
                //print(recipesByIngredient)
                //print(RecipeItem.recipesByIngredient)
                //await dataSource.apply(collectionSnapshot, animatingDifferences: true) /***Se recarga la vista de dataSource*/
                dataSource.apply(collectionSnapshot, animatingDifferences: true, completion: {
                    self.dataSource.apply(self.collectionSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print (error)
            }
        }
    }
    
    // MARK: Registrar celdas y vistas suplementarias a collectionView
    /*Se registra tanto el layout en collectionView y tambien las dos celdas y las la vista suplemetaria*/
    func setUpCollectionView(){
        collectionView.delegate = self
        //Establecer el layout en el collectionView
        collectionView.collectionViewLayout = createLayout()
        //Registrar Celdas
        collectionView.register(UINib(nibName: "ListRecipeDetailCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "ListRecipeDetailCVC")
        collectionView.register(UINib(nibName: "IngredientRecipeListCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "IngredientRecipeDetailCVC")
        //Registrar Vistas suplementarias
        collectionView.register(RecipeListLineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: RecipeListLineView.reuseIdentifier)
    }
    
    
    //MARK: Establecer Data Source de collectionView
    /*Usando UICollectionViewDiffableDataSource se agregan los valores de las recetas e ingredientes en cada celda correspondiente teniendo en cuenta que son dos celdas diferentes.
     Tambien se agregan las lineas de separacion */
    func configureDataSource () {
        dataSource = UICollectionViewDiffableDataSource<Section,RecipeItem> (collectionView: collectionView, cellProvider: {
            (collectionView, indexPath, item) -> UICollectionViewCell in
            // Se inicializa el Data Sourse para cada seccion
            let section = self.sections[indexPath.section]
            switch section {
            case .ingredients: //Para la seccion de ingredientes
                // Se instancia una celda para un ingrediente
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientRecipeDetailCVC", for: indexPath) as! IngredientRecipeListCollectionViewCell /***Se obtiene la celda para presentar los ingredinetes obtenidos*/
                cell.delegate = self /***Asignamos el delegado para eliminar el ingrediente al presionar el boton x*/
                let imagePNG = item.ingredientRecipeList?.imagePNG
                let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: imagePNG!, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
                self.collectionViewImageTasks[indexPath] = Task.init{/***Creamos una Tak y la gregamos al arreglo para despues borrarla*/
                    /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                     Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                     */
                    if let image = try? await sendRequest(fetchIngredientImage) {
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se agrega la imagen a la celda
                            self.hideXButton(cell: cell) /***En caso de que solo queda un ingrediente, su boton de x se ocultara***/
                            cell.setUpIngredient(ingredient: item.ingredientRecipeList!, image: image)/***Se usa el metodo SetUpIngredient para poder enviar la informacion del ingrediente y presentarlo */
                        }
                    }
                    self.collectionViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
                    
                }
                return cell
            case .recipes: /***En caso de que la celda sea para presentar una receta*/
                // se instancia una celda de la categotia de tipo de receta
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListRecipeDetailCVC", for: indexPath) as! ListRecipeDetailCollectionViewCell /***Se obtiene la celda para presentar las recetas obtenidas*/
                cell.setUpRecipeByIngredient(item.recipeByIngredient!)/***Se usa el metodo setUpRecipeByIngredient para poder enviar la informacion de la receta a ListRecipeDetilCollectionViewCell y presentarla */
                let fetchRecipeImage = FetchRecipeImage(url: item.recipeByIngredient?.image ?? self.backgroundRecipeImageURL) /***Realizamos una instancia de FetchRecipeImage para poder realizar un pedido de una imagen***/
                self.collectionViewImageTasks[indexPath] = Task.init{
                    if let image = try? await sendRequest(fetchRecipeImage){
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se agrega la imagen a la celda
                            cell.recipeImage.image = image
                        }
                    }
                    self.collectionViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
                }
                return cell
            }
        })
        
        
        //MARK: Establecer el data source para la vista suplementaria
        dataSource.supplementaryViewProvider = {collectionView,kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.topLine:
                //Para la linea de separacion:
                //Se instancia una vista con una linea de separacion para cada seccion
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RecipeListLineView.reuseIdentifier, for: indexPath) as! RecipeListLineView
                return lineView
            default:
                return nil
            }
        }
        
        dataSource.apply(collectionSnapshot)/***Aparecer la informacion de las celdas al iniciar la vista***/
    }
    
    //MARK: Creaccion del SnapShot para las secciones e RecipeItem
    var collectionSnapshot: NSDiffableDataSourceSnapshot<Section,RecipeItem> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,RecipeItem>()/***SnapShot vacio*/
        //Instancias las diferentes secciones
        let ingredients = Section.ingredients
        let recipes = Section.recipes
        //Agreggar las diferentes seccion e Items al SnapShot
        snapshot.appendSections([ingredients, recipes])
        snapshot.appendItems(RecipeItem.ingredientsForRecipeSearch,toSection: ingredients)
        snapshot.appendItems(RecipeItem.recipesByIngredient, toSection: recipes)
        
        sections = snapshot.sectionIdentifiers/***Se agregan los tipo de secciones a presentar a sections*/
        return snapshot
    }
    
    //MARK: Creacion del Collection View Layout
    /*Se crea el diseño de las dos celdas diferentes y la vista suplementaria*/
    func createLayout() -> UICollectionViewLayout{
        let layout = UICollectionViewCompositionalLayout{(sectionIndex, layoutEnvironment)-> NSCollectionLayoutSection? in
            
            // Tamaño  y posicion de las linea superior
            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale /***se define la altura de la linea de separacion*/
            let lineViewSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(lineItemHeight))
            let topLineView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineViewSize, elementKind: SupplementaryViewKind.topLine, alignment: .top)
            // Establecer el contentInsets de la vista suplementaria
            let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            topLineView.contentInsets = contentInsets
            
            //Se establece el diseño de las dos diferentes celdas
            let section = self.sections[sectionIndex]
            switch section {
            case.ingredients:
                //Se define el diseño de la celda encargada de mostrar diferentes ingredientes
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalWidth(2/7)), subitems: [item])
                //group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0 , bottom: 0, trailing: 10)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 25)
                section.orthogonalScrollingBehavior = .groupPaging /***Establecemos que esta celda se desplace de manera ortogonal*/
                
                return section
            case .recipes:
                //Se define el diseño de la celda encargada de mostrar las diferentes recetas por tipo
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(9/20)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [topLineView] /***Se agrega una linea superior al iniciar las recetas*/
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 25, bottom: 15, trailing: 25)
                
                return section
            }
        }
        return layout
    }
    
    
    //MARK: Actualizacion visual extra de la pantalla
    // metodo que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Ingrediets"
       
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(editFilterToIngredients))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Search List", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }

    //MARK: Editar los filtros
    @objc func editFilterToIngredients(){
        print("aplicar filtros")
        // instanciamos una vista para presentarla
        let recipeListByIngredientFilterStoryboard = UIStoryboard(name: "RecipeListByIngredientFilter", bundle: .main)
        //Instanciamos un RecipeListByCategoryFilterViewController
        if let recipeListByIngredientFilterViewController = recipeListByIngredientFilterStoryboard.instantiateViewController(withIdentifier: "RecipeListByIngredientFilterVC") as? RecipeListByIngredientFilterViewController {
            recipeListByIngredientFilterViewController.delegate = self
            recipeListByIngredientFilterViewController.ignorePantry = ignorePantry
            recipeListByIngredientFilterViewController.numRanking = ranking
            // realizamos la presentacion de tipo push para la siguiente vista
            present(recipeListByIngredientFilterViewController, animated: true)
            //navigationController?.pushViewController(recipeListByCategoryFilterViewController, animated: true)
        }
    }
     
}


//MARK: Extension del delegadpo del collectionView
extension RecipeListByIngredientViewController: UICollectionViewDelegate {
    //MARK: En caso de seleccionar una receta o ingrediente
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPathforIngredients = IndexPath(row: 0, section: 1)/***Creamos un indexPath con la seccion de recetas para saber si estamos presinando un ingredinte o una receta*/
        guard indexPathforIngredients.section == indexPath.section else {return}
        /***En caso de que se presione alguna receta se podra ver los detalle de la misma en otra vista***/
            // instanciamos una vista para presentarla
            let recipeDetail = UIStoryboard(name: "RecipeDetail", bundle: .main)
            //Instanciamos un RecipeDetailViewController
        if let recipeDetailViewController = recipeDetail.instantiateViewController(withIdentifier: "RecipeDetailVC") as? RecipeDetailViewController {
            //recipeDetailViewController.namee = "pasamos"
            recipeDetailViewController.id = RecipeItem.recipesByIngredient[indexPath.row].recipeByIngredient?.id /***Enviamos el id de la receta para poder ver sus detalles en la siguiente vista***/
            //MARK: BORRAR PENDIENTE
            recipeDetailViewController.name = RecipeItem.recipesByIngredient[indexPath.row].recipeByIngredient?.name
            // realizamos la presentacion de tipo push para la siguiente vista
            self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
        }
        
    }
    //En caso de que se haya terminado de mostrar la celda con el ingrediente o la receta con su respectiva imagen
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionViewImageTasks[indexPath]?.cancel() /***Cancelamos la tarea de obtencion de la imagen en caso de que no se requiera */
    }

}
//MARK: Extension para eliminar ingrediente al presionar el boton X
extension RecipeListByIngredientViewController: IngredientRecipeListCollectionViewCellDelegate {
    func ingredientRecipeListCollectionViewCell(_ controller: IngredientRecipeListCollectionViewCell) {
        if let indexPathIngredient = collectionView.indexPath(for: controller){
            /***Encontramos el indice que le corresponde al ingrediente con la x presionada*/
            //Eliminamos el ingrediene del datasource del los arreglos que contienen la informacion de los ingredientes
            nameOfIngredients.remove(at: indexPathIngredient.row)
            imageOfIngredients.remove(at: indexPathIngredient.row)
            setUpIngredients () /***Se actualiza los items de la primera seccion del data source que es de los ingredientes ***/
           
            let stringIngredients = formattedString(ingredients: nameOfIngredients)/***Obtenemos el string adecuado de los ingredientes para poder realizar la nueva  solicitud de red*/
            //Actaulizar el data source de los ingredientes principalmente para evitar que el boton x quede visible si solo queda un ingrediente
            if #available(iOS 15.0, *){
                /*En iOS 14 y versiones anteriores llamar a apply(snapshot, animatingDifferences: true) realizaría una diferencia en la fuente de datos y solo actualizaría las celdas en las que cambiaron los datos.
                 A partir de iOS 15, Para volver a cargar toda la tabla/colección sin diferencias,llamar a applySnapshotUsingReloadData(_:completion:) */
                dataSource.applySnapshotUsingReloadData(collectionSnapshot)
            }else {
                
                dataSource.apply(collectionSnapshot)
            }
            
            requestRecipesByIngredient(ingredients: stringIngredients)/***Metodo para realizar una solicitud de red para poder recibir las nuevas recetas con los ingredientes seleccionados, en este metodo tambien realizamos un reset a las secciones */
        }
        
        
    }
    //MARK: metodo para ocultar el boon x
    func hideXButton (cell:  IngredientRecipeListCollectionViewCell){
        //En caso de que solo quede un ingrediente en la seccion de ingredientes, el boton del ingrediente se ocultara para no tener que tener una seccion de recetas vacia
        if RecipeItem.ingredientsForRecipeSearch.count == 1  {
            cell.buttonToCancelIngredient.isHidden = true /***Se oculta el boton*/
        }
    }
    
    
}

//MARK: Extension para recibir informacion para filtrar las recetas
extension RecipeListByIngredientViewController: RecipeListByIngredientFilterViewControllerDelegate {
    func recipeListByIngredientFilterViewController(_ controller: RecipeListByIngredientFilterViewController, ranking: Bool, ignorePantry: Bool) {
        /*Asignar los valores de el metodo anterior a los valores de los inicializaciones generales ranking e ignorePantry */
        let numRanking = ranking == true ? 1 : 2
        self.ranking = numRanking
        self.ignorePantry = ignorePantry
         let stringIngredients = formattedString(ingredients: nameOfIngredients)/***Obtenemos el string adecuado de los ingredientes para poder realizar la nueva  solicitud de red*/
        requestRecipesByIngredient(ingredients: stringIngredients)/***Metodo para realizar una solicitud de red para poder recibir las nuevas recetas con los ingredientes seleccionados, en este metodo tambien realizamos un reset a las secciones */
    }
    
    
}
