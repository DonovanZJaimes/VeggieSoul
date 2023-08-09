//
//  RecipeSearchListViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 02/07/23.
//
//MARK: INFO:
/*Vista que nos ayudara a buscar las recetas dependiendo si queremos buscarlar por ingredinetes o por su nombre*/

import UIKit

class RecipeSearchListViewController: UIViewController {
    
    
    //MARK: Definir vistas suplementarias
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        
    }
    
    //MARK: Outlets del storyboard
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var lineIngredientsOrRecipes: UIView!
    @IBOutlet var searchRecipesButton: UIButton!
    @IBOutlet var ButtonToIngredients: UIButton!
    @IBOutlet var buttonToRecipes: UIButton!
    @IBOutlet var hintView: UIView!
    
    //MARK: Inicializaciones generles
//    var dataSourse: UICollectionViewDiffableDataSource<Section, ItemAutocomplete>!
    var searchController = UISearchController()
    var ingredientIDFromPeviousView: Int?
    var imageLoadTasks: [IndexPath : Task<Void, Never>] = [:] /***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    

    //MARK: Tipos de layout
    // Definir los dos tipos de vista que puede tener los layout
    enum Layout {
        case vertical /***Layout que aparece al realizar una busqueda en el searchController*/
        case horizontal/***Layout que aparece para mostrar los ingredientres agregados para buscar recetas*/
    }
    var layout: [Layout: UICollectionViewLayout] = [:] /***Para poder pasar de un layout a otro se realiza un diccionario que contiene cada uno*/
    
    //Actualiza el layout que se estara ocupando
    var activeLayout: Layout = .horizontal { /***Definimos que el layout de inicio es para presentar ingredientres agregados para buscar receta*/
        didSet {
            if let layout = layout[activeLayout] {
                self.collectionView.reloadItems(at: self.collectionView.indexPathsForVisibleItems)
                //print("cambiamos bonito")/***Es importante llamar a reloadItems antes de que se actualice el diseño de la vista de colección,  para una transición fluida entre los diseños.*/
                collectionView.setCollectionViewLayout(layout, animated: true) /***Establecemoms el nuevo layout a mostrar***/
                refreshHintView() /***Actualizamos la hintView para ocultarla o esconderla*/
                refreshSearchRecipesButton () /***Actualizamos el searchRecipesButton para ocultarlo o esconderlo*/
            }
        }
    }
    
    //MARK: Tipo de busqueda
    //Definir que tipo de busqueda se realizara, por ingredientes o por recetas
    enum SearchType {
        case recipes /***Opcion para buscar por el nombre de rectas*/
        case ingredients /***Opcion para buscar por el nombre de igredientes*/
    }
    var activeSearchType: SearchType = .ingredients /***Se menciona cual tipo de busqueda se esta realizando***/
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController() /***Actualizamos el search controller para poder hacer las busquedas*/
        IngredientIDFromPeviousView () /***Se verifica si al iniciar esta vista se tiene que presentar un ingrediente */
        updataCollectionView() /***Actualizamos el collectionView como su collectionViewLayout, celdas, data source y delegado*/
        setupHintView ()/***Actualizammos la hint view*/
        configureNavigationItem () /***Configuramos el boton y el titulo de navigation item ***/
        configureButtonToIngredients() /***Conigura la vista del bton para poder buscar recetas*/
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        activeSearchType = .ingredients /***Hacer que cada vez que aparesca esta vista el modo de busqueda sea por ingredientes*/
        refreshHintView() /***Actualizamos la hintView para ocultarla o esconderla*/
        refreshSearchRecipesButton () /***Actualizamos el searchRecipesButton para ocultarlo o esconderlo*/
    }
    
    //MARK: Actualizar el search Controller
    func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
    }
    
    //MARK: Verificacion de envio de un ingrediente de la vista anterior
    func IngredientIDFromPeviousView () {
        /*Se verifica si caundo se paso a esta vista tambien lo hizo con un ID que contiene un ingrediente o no, si es asi se podra agregar el ingrediente  a la colleccion de ItemAutocomplete.addedIngredients*/
        if ingredientIDFromPeviousView != nil {
            let selectedIngredient = InformationOfAnIngredient(id: ingredientIDFromPeviousView!)
            Task {
                do{
                    let ingredient = try await sendRequest(selectedIngredient)
                    ItemAutocomplete.addedIngredients = [ItemAutocomplete.ingredient(ingredient)]
                    refreshHintView() /***Actualizamos la hintView para ocultarla o esconderla*/
                    refreshSearchRecipesButton () /***Actualizamos el searchRecipesButton para ocultarlo o esconderlo*/
                }catch {
                    print(error)
                }
            }
        }
    }
    
    //MARK: Configurar el collectionView
    func updataCollectionView() {
        //Se agregan los dos tipos de layout con sus respectivas funciones
        layout[.vertical] = createLayoutForIngredientsOrRecipes()
        layout[.horizontal] = createLayoutForAddedIngredients()
        //Se establece el layout al collection view
        if let layout = layout[activeLayout] {
            collectionView.collectionViewLayout = layout /***Al inicio se podra ver que el layout inicial sera el horizontal*/
        }
        
        //Se declara quien sera quie realice el data source y el delegado del collecionView
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Se registran las dos celdas que ocupara este collection View
        collectionView.register(UINib(nibName: "IngredientAndRecipeForSearchCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "IngredientAndRecipeForSearchCVC")
        collectionView.register(UINib(nibName: "IngredientsForRecipesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "IngredientsForRecipesCVC")
        
        // Se registran las vistas suplementarias
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header , withReuseIdentifier: HeaderView.reuseIdentifier)/***Esta vista se tomo de la anterior carpeta que es RecipeSearchPage ***/
        //collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
    }
    
    //MARK: Configuracion de la hintView
    //Esta funcion esta encargada de configurar la hintView
    func setupHintView () {
        //Le damos una curvatura y un borde de color a la hintView
        hintView.layer.cornerRadius = hintView.frame.height / 3
        let borderColor = UIColor(named: "Opaque Separator Color")
        hintView.layer.borderColor = borderColor?.cgColor
        hintView.layer.borderWidth = 1
    }
    
    //Esta funcion esta encargada de poder mostrar u ocultar la hintView
    func refreshHintView () {
        //Solo se podra ver esta vista de sugerencia cuando la layout este en hoizontal y no se tenga ningun ingrediente agregado
        if activeLayout == .horizontal && ItemAutocomplete.addedIngredients.count == 0 {
            hintView.isHidden = false /***Aparecemos la vista*/
        } else {
            hintView.isHidden = true /***Ocultamos la vista*/
            
        }
    }

    //MARK: Configuracion del boton para buscar recetas
    //Esta funcion esta encargada de poder mostrar u ocultar la hintView
    func refreshSearchRecipesButton () {
        //Solo se podra ver esta vista de sugerencia cuando la layout este en hoizontal y  se tenga algun ingrediente agregado
        if activeLayout == .horizontal && ItemAutocomplete.addedIngredients.count != 0 {
            searchRecipesButton.isHidden = false /***Aparecemos el boton*/
        } else {
            searchRecipesButton.isHidden = true /***Ocultamos el boton*/
        }
    }
    
    //MARK: Presentar los Ingredientes en el collectionView
    // metodo encargado de actualizar el activeSearchType y el activeLayout para una correcta busqueda
    @IBAction func selectIngredientsForSearchWithButton(_ sender: UIButton) {
        self.searchController.searchBar.resignFirstResponder()
        activeSearchType = .ingredients /***Hacer que cada vez que se presione esta boton  el modo de busqueda sea por ingredientes*/
        collectionView.reloadData()
        activeLayout = .horizontal /***Hacer que el layout sea horizontal mostrando los ingredientes agregados*/
        animateLineBetweenButtons(buttonWidth: sender.bounds.width, direction: activeSearchType)/***Realizamos una animacion pra la view que esta debajo de los botones de ingredientes y recetas*/
    }
    
    //MARK: Presentar las recetas en el collectionView
    @IBAction func selectRecipesForSearchWithButton(_ sender: UIButton) {
        // metodo encargado de actualizar el activeSearchType y el activeLayout para una correcta busqueda
        self.searchController.searchBar.resignFirstResponder()
        activeSearchType = .recipes /***Hacer que cada vez que se presione esta boton  el modo de busqueda sea por el nombre de receta*/
        collectionView.reloadData()/***Antes de cambiar el layout se debe actualizar  la data para eviat problemas */
        //MARK: BORRAR PENDIENTE
        activeLayout = .horizontal
        //activeSearchType = .recipes /***Hacer que cada vez que se presione esta boton  el modo de busqueda sea por el nombre de receta*/
        //MARK: AL REVES PENDIENTE
        animateLineBetweenButtons(buttonWidth: sender.bounds.width, direction: activeSearchType) /***Realizamos una animacion pra la view que esta debajo de los botones de ingredientes y recetas*/
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
            self.lineIngredientsOrRecipes.transform = CGAffineTransform.init(translationX: translationInX, y: 0)
        }
    }
    
   //MARK: Creacion de los layouts
    //Layout que se ocupara para mostrar los ingredientes agregados y que se podran ocupar para realizar recetas
    func createLayoutForAddedIngredients () -> UICollectionViewLayout {
        // Item del layout
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        // Group del layout
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/4), heightDimension: .fractionalHeight(0.4)), subitems: [item]) /***Sera un solo grupo con todos los items ***/
        // Section del layout
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        section.orthogonalScrollingBehavior = .groupPaging /***Se quiere que los ingredientes se muevan de manera ortogonal***/
        
        //Esto le dice al diseño que todas las secciones tendrán un elemento complementario adjunto a uno de sus límites.
        //section.boundarySupplementaryItems = [lineView()]
        section.boundarySupplementaryItems = [ generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //Layout que se ocupara para mostrar la lista de los ingredientes o recetas que se encontraran al hacer la busqueda
    func createLayoutForIngredientsOrRecipes () -> UICollectionViewLayout {
        // Item del layout
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        // Group del layout
        let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .estimated(45)), subitems: [item]) /***Sera un solo grupo con todos los items ***/
        // Section del layout
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 10)
        
        //Esto le dice al diseño que todas las secciones tendrán un elemento complementario adjunto a uno de sus límites.
        //section.boundarySupplementaryItems = [lineView()]
        section.boundarySupplementaryItems = [ generateHeader()]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    func generateHeader() ->
        NSCollectionLayoutBoundarySupplementaryItem {
            /***Este método crea y devuelve un NSCollectionLayoutBoundarySupplementaryItem configurado para tener el ancho completo de su contenedor y 40 puntos de alto. .***/
            let header = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: NSCollectionLayoutSize( widthDimension: .fractionalWidth(1), heightDimension: .absolute(40) ),
                /***El tipo se establece en headerKind y la alineación del elemento de límite se establece en la parte superior del contenedor. ***/
                elementKind: SupplementaryViewKind.header ,alignment: .top
            )
        /***Establecer la propiedad pinToVisibleBounds en true le dice a la vista de colección que cree un encabezado "sticky" que se fija en la parte superior de la vista de colección y solo se desplaza cuando su contenedor asociado ya no está visible. Es posible que haya visto un comportamiento similar en las vistas de tabla***/
            header.pinToVisibleBounds = true
        
            return header
        
    }
    //MARK: BORRAR PENDIENTE
//    func lineView () -> NSCollectionLayoutBoundarySupplementaryItem {
//        //Se diseña las dimensiones y posicion de la vista superior
//        //let layoutEnvironment =  NSCollectionLayoutEnvironment()
//        // Tamaño  y posicion de las lineas inferior y superior
//        //let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale /***se define la altura de la linea de separacion*/
//        let lineViewSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .absolute(2))
//        let topLineView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineViewSize, elementKind: SupplementaryViewKind.topLine, alignment: .top)
//
//        // Establecer el contentInsets de las vista
//        let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
//        topLineView.contentInsets = contentInsets
//
//        return topLineView
//    }
    
    
    //MARK: Buscar recetas con los ingredientes agregados
    @IBAction func searchRecipes(_ sender: Any) {
        // instanciamos una vista para presentarla
        let recipeListByIngredientStoryboard = UIStoryboard(name: "RecipeListByIngredient", bundle: .main)
        //Instanciamos un RecipeListByIngredientViewController
        if let recipeListByIngredientViewController = recipeListByIngredientStoryboard.instantiateViewController(withIdentifier: "RecipeListByIngredientVC") as? RecipeListByIngredientViewController {
            //Agregamos los nombre y nombre de imagenes dos variables para pasarlas a la siguiente vista "RecipeListByIngredientViewController"
            var listOfIngredients: [String] = []
            //["apple", "banana chips"]
            ItemAutocomplete.addedIngredients.forEach{ingredient in listOfIngredients.append(ingredient.ingredient!.name)  } /***Agregamos ls nombres de los ingredientes selecionados al arreglo de nombres*/
            var imageOfIngredients: [String] = []
            //["apple.jpg", "limoncello.jpg"]
            ItemAutocomplete.addedIngredients.forEach{image in imageOfIngredients.append(image.ingredient!.image)} /***Agregamos ls nombres de las imagenes de los ingredientes selecionados al arreglo de imagenes */
            recipeListByIngredientViewController.nameOfIngredients = listOfIngredients/***Los nombres de ingredientes los pasamos a la siguiente vista*/
            recipeListByIngredientViewController.imageOfIngredients = imageOfIngredients /***Los nombres de las imagenes de los ingredientes los pasamos a la siguiente vista*/
            // realizamos la presentacion de tipo push para la siguiente vista
            navigationController?.pushViewController(recipeListByIngredientViewController, animated: true)
        }
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Search"
       
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Recipes", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Congiguracion del boton para busqueda
    func configureButtonToIngredients(){
        searchRecipesButton.layer.cornerRadius = 5/***Redondeamos el boton */
    }

    
}
//MARK: Extension para seleccion de celdas dataSource
extension RecipeSearchListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isHorizontal = activeLayout == .horizontal ? true : false /***Se analiza en cual layout se trabajara, en vertical u horizontal*/
        switch activeSearchType{
        //Verificamos que cantidad de items se tiene que retornar dependiendo el tipo de seccion
        case .ingredients:
            if isHorizontal {
                return  ItemAutocomplete.addedIngredients.count
            } else {
                return ItemAutocomplete.ingredientsToAdd.count
                
            }
        case .recipes:
            return ItemAutocomplete.foundRecipes.count
        }
        //MARK: BORRAR PENDIENTE
        /*
        //Se verifica el el el layout activo para poder enviar en numero de filas adecuado
        switch activeLayout {
        case .vertical:
            //Si el layout activo es vertical:
            return  activeSearchType == .ingredients ? ItemAutocomplete.ingredientsToAdd.count : ItemAutocomplete.foundRecipes.count /***Se hace otra comprobacion, ahora para saber si la busqueda se esta realizando con ingredientes o recetas***/
        case .horizontal:
            //Si el layout activo es horizontal:
            //activeSearchType = .ingredients
            return  ItemAutocomplete.addedIngredients.count
        }*/
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isHorizontal = activeLayout == .horizontal ? true : false /***Se analiza en cual layout se trabajara, en vertical u horizontal*/
        // Se verifica cual busqueda se esta realizando, por ingredientes o por recetas
        switch activeSearchType {
        case .ingredients: /***En caso de que la busqueda se realize por ingredientes*/
            //Ahora se verifica si el layout que se presenta en mdo vertical u horizontal
            if isHorizontal {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientsForRecipesCVC", for: indexPath) as! IngredientsForRecipesCollectionViewCell/***Se obtiene la celda para presentar los ingredinetes agregados*/
                let ingredient = ItemAutocomplete.addedIngredients[indexPath.item]/***Se obtiene el item a trabajar */
                let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: ingredient.ingredient!.image, isIngredient: true) /***Se obtiene el tipo on la informacion de la imagen del ingrediente*/
                imageLoadTasks[indexPath] = Task.init{ /***Se inicia la tarea y se agrega al arreglo de tasks***/
                    /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                     Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                     */
                    if let image = try? await sendRequest(fetchIngredientImage) {
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se actualiza la informacion en la celda
                            cell.setUpIngredient(ingredient: ingredient.ingredient!)
                            cell.ingredientImage.image = image
                            cell.delegate = self /***Esta linea es para borrar los ingredientes si se presiona el boton X de la celda***/
                        }
                    }
                    imageLoadTasks[indexPath] = nil /***Se borra la task con la imagen, esto por memoria***/
                }
                return cell
            }else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientAndRecipeForSearchCVC", for: indexPath) as! IngredientAndRecipeForSearchCollectionViewCell /***Se obtiene la celda para presentar los ingredinetes para agregar*/
                let ingredient = ItemAutocomplete.ingredientsToAdd[indexPath.item]/***Se obtiene el item a trabajar */
                let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: ingredient.ingredient!.image, isIngredient: true) /***Se obtiene el tipo on la informacion de la imagen del ingrediente*/
                imageLoadTasks[indexPath] = Task.init{ /***Se inicia la tarea y se agrega al arreglo de tasks***/
                    /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                     Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                     */
                    if let image = try? await sendRequest(fetchIngredientImage) {
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se actualiza la informacion en la celda
                            cell.setUpIngredient(ingredient: ingredient.ingredient!)
                            cell.ingredientOrRecipeImage.image = image
                        }
                    }
                    imageLoadTasks[indexPath] = nil
                }
                return cell
            }
        case .recipes:
            //En caso de que la busqueda sea por recetas:
            //print("entramos")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientAndRecipeForSearchCVC", for: indexPath) as! IngredientAndRecipeForSearchCollectionViewCell/***Se obtiene la celda para presentar los ingredinetes para agregar*/
            let recipe = ItemAutocomplete.foundRecipes[indexPath.item]/***Se obtiene el item a trabajar */
            let fetchRecipeImage = FetchRecipeImageID(id: String(recipe.recipe!.id), type: recipe.recipe!.imageType)/***Se obtiene el tipo on la informacion de la imagen de la receta*/
            imageLoadTasks[indexPath] = Task.init{ /***Se inicia la tarea y se agrega al arreglo de tasks***/
                /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                 Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                 */
                if let image = try? await sendRequest(fetchRecipeImage) {
                    if let currentIndexPath = self.collectionView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        //Se actualiza la informacion en la celda
                        cell.setUpRecipe(recipe: recipe.recipe!)
                        cell.ingredientOrRecipeImage.image = image
                    }
                }
                imageLoadTasks[indexPath] = nil
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        /***Cuando la collection view solicita un encabezado, se llama a este método para configurar la vista. De manera similar a los elementos de vista de colección regulares, una vista reutilizable se quita de la cola, se configura con el título de la sección y se devuelve.
         ***/
        let header =
           collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.reuseIdentifier, for:  indexPath) as! HeaderView
        
        let isHorizontal = activeLayout == .horizontal ? true : false /***Se analiza en cual layout se trabajara, en vertical u horizontal*/
        // Se verifica cual busqueda se esta realizando, por ingredientes o por recetas
        switch activeSearchType {
        case .ingredients: /***En caso de que la busqueda se realize por ingredientes*/
            //Ahora se verifica si el layout que se presenta en mdo vertical u horizontal
            if isHorizontal {
                header.setTitle( "Added Ingredients")
            } else {
                header.setTitle( "List Of Ingredients")
            }
        case .recipes:
            header.setTitle( "Recipe List")
        }
    //MARK: BORRAR PENDIENTE
//        let topView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath)
//
//        return topView
        return header
    }
}

//MARK: Extension para seleccion de celdas delegado
extension RecipeSearchListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Se verifica si se presiono una celda cuando se estaba en la seccion de recetas o ingredientes
        switch activeSearchType {
        case .ingredients:
            //Se verifica si se presiono cuando la lista estaba vertical
            if activeLayout == .vertical {
                ItemAutocomplete.addedIngredients.append(ItemAutocomplete.ingredientsToAdd[indexPath.item])/***Se agrega el item de manera vertical presionado a la lista de ingredientes agregados*/
                self.searchController.searchBar.resignFirstResponder()
                collectionView.reloadData()/***Antes de cambair el tipo de layout se debe  actualizar la data para evitar problema de numero deitems en seccion*/
                activeLayout = .horizontal /***Se cambia el layout a horizontal para poder ver los cambios y los ingredientes agregados recientemente***/
                collectionView.reloadData()
                self.searchController.searchBar.text = ""
            }
        case .recipes:
            /***En caso de que se presione alguna receta se podra ver los detalle de la misma en otra vista***/
                // instanciamos una vista para presentarla
                let recipeDetail = UIStoryboard(name: "RecipeDetail", bundle: .main)
                //Instanciamos un RecipeDetailViewController
                if let recipeDetailViewController = recipeDetail.instantiateViewController(withIdentifier: "RecipeDetailVC") as? RecipeDetailViewController {
                    //recipeDetailViewController.namee = "pasamos"
                    recipeDetailViewController.id = ItemAutocomplete.foundRecipes[indexPath.item].recipe?.id /***Se envia el id de la receta selecionada en la fila y seccion adecuada*/
                    // realizamos la presentacion de tipo push para la siguiente vista
                    self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
                }
            //MARK: BORRAR PENDIENTE
            /*
            //En caso de que se presiono estando en la busqueda de recetas
            // instanciamos una vista para presentarla
            let recipeListByIngredientStoryboard = UIStoryboard(name: "RecipeListByIngredient", bundle: .main)
            print("18.2")
            //Instanciamos un RecipeListByIngredientViewController
            if let recipeListByIngredientViewController = recipeListByIngredientStoryboard.instantiateViewController(withIdentifier: "RecipeListByIngredientVC") as? RecipeListByIngredientViewController {
                print("18.3")
                // realizamos la presentacion de tipo push para la siguiente vista
                navigationController?.pushViewController(recipeListByIngredientViewController, animated: true)
            }*/
        }
        
    }
}


//MARK: Extension para el protocolo de UISearchResultsUpdating
extension RecipeSearchListViewController: UISearchResultsUpdating, UISearchBarDelegate {
    //MARK: Seleccionar celda
    func updateSearchResults(for searchController: UISearchController) {
        //Se verifica si el texto del searchbar no sea nulo
        if let searchString = searchController.searchBar.text,
           searchString.isEmpty == false {
            //Se verifica que tipo de busqueda se realizara, por ingredientes o por recetas
            switch activeSearchType {
            case .ingredients:
                let ingredientsToAdd = AutocompleteIngredient(query: searchString)
                Task.init{
                    do{
                        let autocompleteIngredients = try await sendRequest(ingredientsToAdd)/***Se obtiene la lista de ingredientes por las letras de la busqueda*/
                        ItemAutocomplete.ingredientsToAdd = autocompleteIngredients.map {ItemAutocomplete.ingredient($0)}/***La lista de los ingredinetes regresadas se agregaran a la arreglo de ItemAutocomplete.ingredientsToAdd para poder verlo*/
                        if activeLayout == .horizontal {
                            //Si el layout estaba en horizontal ahora pasara avertical para ver la lista obtenida
                            collectionView.reloadData() /***Antes de cambair el tipo de layout se debe  actualizar la data para evitar problema de numero de items en seccion*/
                            activeLayout = .vertical
                        }
                        collectionView.reloadData()
                    }catch{
                        print(error)
                    }
                }
            case .recipes:
                //En caso de que la busqueda se este realizando por recetas:
                let foundRecipes = AutocompleteRecipe(query: searchString)
                Task.init{
                    do{
                        let autocompleteRecipes = try await sendRequest(foundRecipes)/***Se obtiene la lista de ingredientes por las letras de la busqueda*/
                        ItemAutocomplete.foundRecipes = autocompleteRecipes.map {ItemAutocomplete.recipe($0)}/***La lista de las recetas regresadas se agregaran a la arreglo de IItemAutocomplete.foundRecipes para poder verlo*/
                        if activeLayout == .horizontal {
                            //Si el layout estaba en horizontal ahora pasara avertical para ver la lista obtenida
                            collectionView.reloadData() /***Antes de cambair el tipo de layout se debe  actualizar la data para evitar problema de numero deitems en seccion*/
                            activeLayout = .vertical
                        }
                        collectionView.reloadData()
                        
                    }catch{
                        print(error)
                    }
                }
            }
        }
        else {
            //Evitamos que se traslapen imagenes en la vista horizontal
            ItemAutocomplete.ingredientsToAdd = []
            ItemAutocomplete.foundRecipes = []
        }
    }
    //MARK: Cancelar busqueda
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Al apretar el boton de cancelar de searchController la layout regresara a horizontal mostrando los ingredientes agregdos
        activeSearchType = .ingredients
        collectionView.reloadData() /***Antes de cambair el tipo de layout se debe  actualizar la data para evitar problema de numero deitems en seccion*/
        activeLayout = .horizontal
    }
   
}
//MARK: Delegado de IngredientsForRecipesCollectionViewCellDelegate para eliminar ingrediente selecionado
extension RecipeSearchListViewController: IngredientsForRecipesCollectionViewCellDelegate{
    func ingredientsForRecipesCollectionViewCell(collectionViewCell: IngredientsForRecipesCollectionViewCell) {
        /*Cada vez que se presiona el boton x del ingrediente selcionado se llamara a essta funcion con un parametro:collectionViewCell
         Este parametro nos permitira saber cual celda se seleciono para poder eliminarla del arreglo de addedIngredients */
        ItemAutocomplete.addedIngredients.removeAll { $0.ingredient?.name == collectionViewCell.ingredientLabel.text } /***Se eliminan todos los ingredientes  del arreglo addedIngredients que tengan un ingrediente con el nombre igual a collectionViewCell.ingredientLabel.text */
        refreshHintView() /***Actualizamos la hintView para ocultarla o esconderla*/
        refreshSearchRecipesButton () /***Actualizamos el searchRecipesButton para ocultarlo o esconderlo*/
        collectionView.reloadData()
    
    }
}
