//
//  SearchPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 25/05/23.
//
//MARK: INFO:
/*Vista para poder presentar diferentes recetas  con diferentes categorias  y un apartado de ingredientes aleatorios*/

import UIKit
class RecepiHomeViewController: UIViewController {
    
    //MARK: Definir un ingrediente
    let starterIngredient = Ingredient(id: 9266, imagePNG: "pineapple.jpg", name: "pineapples")/***En caso de que la primera receta en pantalla no tenga ingredientes se pondra ese en la primera fila, esto para que la primera seccion no se quede vacia */
    let backgroundRecipeImageURL = "https://c8.alamy.com/compes/2j7jf0e/los-alimentos-veganos-para-la-ecologia-y-el-medio-ambiente-ayudan-al-mundo-con-ideas-ecologicas-2j7jf0e.jpg" /***En caso de que la imagen de la reeta no tenga imagen, se colocara esta*/

    //MARK: Definrir secciones
    enum Section: Hashable {
        case ingredients
        case type(String)
    }
    
    //MARK: Definir vistas suplementarias
    enum SupplementaryViewKind {
        static let header = "header"
        static let topLine = "topLine"
        static let bottomLine = "bottomLine"
    }
    
    //MARK: definir Outlets del Storyboard
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var imagePersonAcount: UIImageView!
    
    
    //MARK: Inicializaciones generles
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! /***Creara una variable abierta implícitamente para la fuente de datos que usa el tipo de sección que acaba de definir para las secciones que se mostraran en pantalla y el tipo de items que estaran dentro ***/
    var sections = [Section]()/***Arreglo de la enumeracion Section que esta arriba***/
    var collectionViewTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    var ingredients: [Ingredient] = []/***Arreglo de los ingredienetes que se veran al inicio de la pantalla*/
    

    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesAndIngredientsSettings () /***Inicializar las recetas e ingredientes iniciales en pantalla*/
        setUpImageAcount() /***Actualizamos la configuracion de la imagen de cuenta que esta al inicio*/
        setUpTitle () /***Configuracos el titulo al inicio de la vista***/
        settupCollectionView()/***Actualizamos el collectionView como su collectionViewLayout, celdas, y delegado*/
        configureDataSource()/***Configuramos el estilo de dataSourse por ocupar UICollectionViewDiffableDataSource*/
        navigationItem.backBarButtonItem?.tintColor = .black

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ItemAutocomplete.addedIngredients = []/***Esta linea elimina todos los ingredientes que fueron agregados en la vista posterior que se encuentra en la carpeta de RecipeSearchList*/
        VariablesFilterRecipes.shared.typeOfMealToFilterRecipes = ""
        VariablesFilterRecipes.shared.typeOfMealsSelected = []
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        collectionViewTasks.forEach {key, value in value.cancel() } /***Concelamos las tareas en caso de que no se requiran cuando nos pasamos a otra vista*/
    }
    
    //MARK: Inicializar las recetas e ingredientes iniciales en pantalla
    func recipesAndIngredientsSettings () {
        //Instanciamos los diferentes tipos de recetas que estaran en la pantalla divididos en secciones
        
        let mainCourseRecipe = RecepiByType(type: "main_course")
        //let dessertRecipe = RecepiByType(type: "dessert")
        //let appetizerRecipe = RecepiByType(type: "appetizer")
        let saladRecipe = RecepiByType(type: "salad")
        //let breakfastRecipe = RecepiByType(type: "breakfast")
        //let soupRecipe = RecepiByType(type: "soup")
        //let beverageRecipe = RecepiByType(type: "beverage")
        
        
        //Realizamos las diferentes tareas, una para cada peicion de tipo de recetas
        //Peticion de plato principal
        Task {
            do{
                let mainCourseRecipes = try await sendRequest(mainCourseRecipe)/***Solicitamos las recetas */
                Item.mainCourseRecipes = mainCourseRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
                ingredients = mainCourseRecipes.recipes[0].ingredients //?? [starterIngredient]/***Para este caso los ingredientes de la primera receta se presentaran aen pantalla y para eso se agregan a este tipo*/
                Item.firstIngredients = ingredients.map {Item.ingredient($0)}/***Con el arreglo de ingredientes obtenidos se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
                //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
                dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
                    self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }
       //MARK: PENDIENTE: REDUCIR CODIGO DE TAREAS
        //Peticion de postre
        /*Task {
            do{
                let dessertRecipes = try await sendRequest(dessertRecipe)/***Solicitamos las recetas */
                Item.dessertRecipes = dessertRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
         //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
         dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
             self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/            }catch{
                print(error)
            }
        }*/
        
         /*
        //Peticion de aperitivo
        Task {
            do{
                let appetizerRecipes = try await sendRequest(appetizerRecipe)/***Solicitamos las recetas */
                Item.appetizerRecipes = appetizerRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
          //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
          dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
              self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }*/
        
        //Peticion de ensaladas
        Task {
            do{
                let saladRecipes = try await sendRequest(saladRecipe)/***Solicitamos las recetas */
                Item.saladRecipes = saladRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
         //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
         dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
             self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }
         /*
        //Peticion de desayuno
        Task {
            do{
                let breakfastRecipes = try await sendRequest(breakfastRecipe)/***Solicitamos las recetas */
                Item.breakfastRecipes = breakfastRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
          //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
          dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
              self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }*/
         /*
        //Peticion de sopa
        Task {
            do{
                let soupRecipes = try await sendRequest(soupRecipe)/***Solicitamos las recetas */
                Item.soupRecipes = soupRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
          //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
          dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
              self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }*/
         /*
        //Peticion de sopa
        Task {
            do{
                let beverageRecipes = try await sendRequest(beverageRecipe)/***Solicitamos las recetas */
                Item.beverageRecipes = beverageRecipes.recipes.map {Item.recipe($0)}/***Con el arreglo de recetas obtenidas se hace otro arreglo que sea de igual formato al de la estructura Item y se lo agregamos a su respectivo arreglo*/
          //await dataSource.apply(recipeSnapshot, animatingDifferences: true)/***Se recarga la vista de dataSource*/
          dataSource.apply(recipeSnapshot, animatingDifferences: true, completion: {
              self.dataSource.apply(self.recipeSnapshot, animatingDifferences: false)}) /***Se recarga la vista de dataSource*/
            }catch{
                print(error)
            }
        }*/
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    //metodo que actualiza la foto de inicio
    func setUpImageAcount() {
        imagePersonAcount.layer.cornerRadius = imagePersonAcount.bounds.height / 2
        let borderColor = UIColor(named: "ColorTeal")
        imagePersonAcount.layer.borderColor = borderColor?.cgColor
        imagePersonAcount.layer.borderWidth = 1.5
    }
    
    // metodo que actualiza el color del titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
    }
    
    
   
    // MARK: Registrar celdas y vistas suplementarias a collectionView
    /*Se registra tanto el layout en collectionView y tambien las dos celdas y las tres vistas suplemetarias*/
    func settupCollectionView() {
        collectionView.delegate = self
        //Establecer el layout en el collectionView
        collectionView.collectionViewLayout = createLayout()
        //Registrar Celdas
        collectionView.register(UINib(nibName: "IngredientHomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "IngredientHomeCVC")
        collectionView.register(UINib(nibName: "RecipeHomeCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "RecipeHomeCVC")
        //Registrar Vistas suplementarias
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.topLine, withReuseIdentifier: LineView.reuseIdentifier)
        collectionView.register(LineView.self, forSupplementaryViewOfKind: SupplementaryViewKind.bottomLine, withReuseIdentifier: LineView.reuseIdentifier)
    }
    
    
    //MARK: Establecer Data Source de collectionView
    /*Usando UICollectionViewDiffableDataSource se agregan los valores de las recetas e ingredientes en cada celda correspondiente teniendo en cuenta que son dos celdas diferentes.
     Tambien se agregan los titulos especificos en cada secion y lineas de separacion */
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item> (collectionView: collectionView, cellProvider: {
          (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            // Se inicializa el Data Sourse para cada seccion
            let section = self.sections[indexPath.section]
            switch section {
            case .ingredients: //Para la seccion de ingredientes
                // Se instancia una celda para un ingrediente
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IngredientHomeCVC", for: indexPath) as! IngredientHomeCollectionViewCell /***Se obtiene la celda para presentar los ingredinetes obtenidos*/
                let imagePNG = item.ingredient!.imagePNG ?? self.starterIngredient.imagePNG
                let fetchIngredientImage = FetchIngredienOrEquipmentImage(nameOfIngredientOrEquipment: imagePNG!, isIngredient: true) /***Realizamos una instancia de FetchIngredienOrEquipmentImage para poder realizar un pedido de una imagen de un ingrediente*/
                self.collectionViewTasks[indexPath]?.cancel()
                self.collectionViewTasks[indexPath] = Task.init {/***Creamos una Tak y la gregamos al arreglo para despues borrarla*/
                    cell.SetUpIngredient(ingredient: item.ingredient!) /***Se usa el metodo SetUpIngredient para poder enviar la informacion de la receta a IngredientHomeCollectionViewCell y presentarla */
                    /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                     Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en collectionView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                     */
                    if let image = try? await sendRequest(fetchIngredientImage) {
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se agrega la imagen a la celda
                            cell.ingredientImage.image = image
                        }
                    }
                    self.collectionViewTasks[indexPath] = nil/***Cancelamos la Task*/
                }
                return cell
            case .type: /***En caso de que la celda sea para presentar una receta*/
                // se instancia una celda de la categotia de tipo de receta
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeHomeCVC", for: indexPath) as! RecipeHomeCollectionViewCell
                let  fetchRecipeImage = FetchRecipeImage(url: item.recipe!.imageURL ?? self.backgroundRecipeImageURL ) /***Realizamos una instancia de FetchRecipeImage para poder realizar un pedido de una imagen***/
                self.collectionViewTasks[indexPath]?.cancel()
                self.collectionViewTasks[indexPath] = Task.init {/***Creamos una Tak y la gregamos al arreglo para despues borrarla*/
                    cell.SetUpRecipe(recipe: item.recipe!) /***Se usa el metodo SetUpRecipe para poder enviar la informacion de la receta a RecipeHomeCollectionViewCell y presentarla */
                    if let image = try? await sendRequest(fetchRecipeImage) {
                        if let currentIndexPath = self.collectionView.indexPath(for: cell),
                           currentIndexPath == indexPath {
                            //Se agrega la imagen a la celda
                            cell.imageRecipe.image = image
                        }
                    }
                    self.collectionViewTasks[indexPath] = nil/***Cancelamos la Task*/
                }
                return cell
//            default:
//                return nil
            }
        })
        //MARK: Establecer el data source para las vistas suplementarias
        // Se inicializa el Data Sourse para cada vista suplementaria
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath -> UICollectionReusableView? in
            
            switch kind {
            case SupplementaryViewKind.header:
                // Para los titulos:
                
                // Se establece el titulo para cada seccion
                let titleSuplementary : String
                let section = self.sections[indexPath.section]
                switch section {
                case .ingredients:  /***Esta seccion no tendra titulo*/
                    return nil
                case .type(let name):
                    titleSuplementary = name /***El nombre de cada seccion para este tipo de celda se establecera en titleSuplementary*/
                }
                //Se instancia una vista con el titulo para cada seccion
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
                headerView.setTitle(titleSuplementary)/***Se llama al metodo de esta vista para establecer el titulo pora cada seccion */
                headerView.delegate = self /***Adoptamos el protocolo de esta vista para poder pasar a la lista de recetas similares*/
                headerView.type = titleSuplementary
                return headerView
                
            case SupplementaryViewKind.topLine, SupplementaryViewKind.bottomLine:
                // Para las lineas de separacion:
                
                //Se instancia una vista con una linea de separacion para cada seccion
                let lineView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LineView.reuseIdentifier, for: indexPath) as! LineView
                return lineView
                
            default:
                return nil
            }
        }
        dataSource.apply(recipeSnapshot) /***Aparecer la informacion de las celdas al iniciar la vista***/
    }
    
    
    //MARK: Creacion del Collection View Layout
    /*Se crea el diseño de las dos celdas diferentes y las 3 vistas suplementarias*/
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            /**Se diseña las dimensiones y posicion de las tres vistas suplemenrias*/
            //Tamaño y posicion del titulo
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
            // Tamaño  y posicion de las lineas inferior y superior
            let lineItemHeight = 1 / layoutEnvironment.traitCollection.displayScale /***se define la altura de la linea de separacion*/
            let lineViewSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.94), heightDimension: .absolute(lineItemHeight))
            let topLineView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineViewSize, elementKind: SupplementaryViewKind.topLine, alignment: .top)
            let bottonLineView = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: lineViewSize, elementKind: SupplementaryViewKind.bottomLine, alignment: .bottom)
            // Establecer el contentInsets de las tres vistas suplementarias
            let contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            topLineView.contentInsets = contentInsets
            bottonLineView.contentInsets = contentInsets
            headerItem.contentInsets = contentInsets
            
            
            
            //Se establece el diseño de las dos diferentes celdas
            let section = self.sections[sectionIndex]
            switch section {
            case .ingredients:
                //Se define el diseño de la celda encargada de mostrar diferentes ingredientes
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 2 , bottom: 5, trailing: 2)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalHeight(1/8)), subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0 , bottom: 0, trailing: 10)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [bottonLineView] /***Se agrega una linea inferior al terminar de mostrar los ingredientes*/
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20 , bottom: 10, trailing: 0)
                section.orthogonalScrollingBehavior = .groupPaging /***Establecemos que esta celda se desplace de manera ortogonal*/
                
                return section
            case .type:
                //Se define el diseño de la celda encargada de mostrar las diferentes recetas por tipo
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(280)), subitems: [item])
                group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15 , bottom: 0, trailing: 0)
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [headerItem, bottonLineView] /***Se agrega un titulo y una linea inferior a cada seccion de este tipo de celda*/
                section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0 , bottom: 25, trailing: 0)
                section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary /***Establecemos que esta celda se desplace de manera ortogonal*/
                
                return section
            }
        }
        return layout
    }
    
    //MARK: Creaccion del SnapShot para las secciones e Item
    var recipeSnapshot: NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>() /***SnapShot vacio*/
        
        //Instancias las diferentes secciones
        let ingredients = Section.ingredients
        let typeSalad = Section.type("Salads")
        let typeBeverage = Section.type("Beverages")
        let typeSoup = Section.type("Soup")
        let typeBreakfast = Section.type("Breakfast")
        let typeMainCourse = Section.type("Main Course")
        let typeAppetizer = Section.type("Appetizer")
        let typeDessert = Section.type("Dessert")
        
        //Agreggar las diferentes seccion e Items al SnapShot
        snapshot.appendSections([ingredients,typeMainCourse,typeSalad, typeBeverage, typeBreakfast, typeSoup, typeAppetizer, typeDessert  ])
        snapshot.appendItems(Item.firstIngredients, toSection: ingredients)
        snapshot.appendItems(Item.saladRecipes, toSection: typeSalad)
        snapshot.appendItems(Item.beverageRecipes, toSection: typeBeverage)
        snapshot.appendItems(Item.soupRecipes, toSection: typeSoup)
        snapshot.appendItems(Item.breakfastRecipes, toSection: typeBreakfast)
        snapshot.appendItems(Item.mainCourseRecipes, toSection: typeMainCourse)
        snapshot.appendItems(Item.appetizerRecipes, toSection: typeAppetizer)
        snapshot.appendItems(Item.dessertRecipes, toSection: typeDessert)
        
        sections = snapshot.sectionIdentifiers/***Se agregan los tipo de secciones a presentar a sections*/
        return snapshot
    }
    
/*
    //MARK: Realizacion del segue para la vista ListSearchPage
    @IBAction func ButtonPressed(_ sender: Any) {
        // instanciamos una vista para presentarla
        let listSearchPage = UIStoryboard(name: "ListSearchPage", bundle: .main)
        //Instanciamos un ListSearchPageTableViewController
        if let listSearchPageTableViewController = listSearchPage.instantiateViewController(withIdentifier: "ListSearchPageTVC") as? ListSearchPageTableViewController {
            listSearchPageTableViewController.namee = "koko"
            // realizamos la presentacion de tipo push para la siguiente vista
            self.navigationController?.pushViewController(listSearchPageTableViewController, animated: true)
        }
    }
    */
    //MARK: Realizacion del segue para la vista RecipeSearchList
    @IBAction func goToRecipeSearch(_ sender: Any) {
        // instanciamos una vista para presentarla
        let recipeSearchList = UIStoryboard(name: "RecipeSearchList", bundle: .main)
        //Instanciamos un RecipeSearchListViewController
        if let recipeSearchListViewController = recipeSearchList.instantiateViewController(withIdentifier: "RecipeSearchListVC") as? RecipeSearchListViewController {
            self.navigationController?.pushViewController(recipeSearchListViewController, animated: true)
        }
    }
    
}
//MARK: Extension para el delegado de ColeccionView
extension RecepiHomeViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let indexPathIngredient = IndexPath(row: 0, section: 0) /***Index para obtener una referencia que tenga para una seccion0 que es para los ingredientes***/
        let sectionCollection = [Item.firstIngredients, Item.mainCourseRecipes, Item.saladRecipes, Item.beverageRecipes, Item.breakfastRecipes, Item.soupRecipes, Item.appetizerRecipes, Item.dessertRecipes] /***Arreglo que contiene todos los ingredientes y recetas ordenadas de la misma forma que se vera en pantalla*/
        let pressedSection = sectionCollection[indexPath.section]/***Se selecciona la secciona en que se presiono la receta*/
        
        //Averiguamos si se presiono una receta o un ingrediente
        if indexPathIngredient.section == indexPath.section { /***En  caso de que se selecione algun ingrediente se pasara a la siguiente vsta para buscar recetas */
            // instanciamos una vista para presentarla
            let recipeSearchList = UIStoryboard(name: "RecipeSearchList", bundle: .main)
            //Instanciamos un RecipeSearchListViewController
            if let recipeSearchListViewController = recipeSearchList.instantiateViewController(withIdentifier: "RecipeSearchListVC") as? RecipeSearchListViewController {
                recipeSearchListViewController.ingredientIDFromPeviousView = Item.firstIngredients[indexPath.row].ingredient!.id
                self.navigationController?.pushViewController(recipeSearchListViewController, animated: true)/***Presentamos la vista en modo push*/
            }
        } else { /***En caso de que se presione alguna receta se podra ver los detalle de la misma en otra vista***/
            // instanciamos una vista para presentarla
            let recipeDetail = UIStoryboard(name: "RecipeDetail", bundle: .main)
            //Instanciamos un RecipeDetailViewController
            if let recipeDetailViewController = recipeDetail.instantiateViewController(withIdentifier: "RecipeDetailVC") as? RecipeDetailViewController {
                //recipeDetailViewController.namee = "pasamos"
                recipeDetailViewController.id = pressedSection[indexPath.row].recipe?.id /***Se envia el id de la receta selecionada en la fila y seccion adecuada*/
                //MARK: BORRAR
                recipeDetailViewController.name = pressedSection[indexPath.row].recipe?.name
                // realizamos la presentacion de tipo push para la siguiente vista
                self.navigationController?.pushViewController(recipeDetailViewController, animated: true)
            }
        }
        
        
    }
    //En caso de que se haya terminado de mostrar la celda con el ingrediente o la receta con su respectiva imagen
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionViewTasks[indexPath]?.cancel()/***Cancelamos la tarea de obtencion de la imagen en caso de que no se requiera ***/
    }
}

//MARK: Extension para el delegado de SectionHeaderViewDelegate
extension RecepiHomeViewController: SectionHeaderViewDelegate {

    //Con este metodo nos encargaremos a ir la vista de todas las recetas similares el tipo que se selcciono
    func sectionHeaderView(reusableView: SectionHeaderView) {
        // instanciamos una vista para presentarla
        let recipeListByCategoryStoryboard = UIStoryboard(name: "RecipeListByCategory", bundle: .main)
        //Instanciamos un RecipeListViewController
        if let recipeListByCategoryViewController = recipeListByCategoryStoryboard.instantiateViewController(withIdentifier: "RecipeListByCategoryVC") as? RecipeListByCategoryViewController {
            // realizamos la presentacion de tipo push para la siguiente vista
            //print(reusableView.type)
            recipeListByCategoryViewController.category = reusableView.type
            navigationController?.pushViewController(recipeListByCategoryViewController, animated: true)
        }
    }
    
    
}
