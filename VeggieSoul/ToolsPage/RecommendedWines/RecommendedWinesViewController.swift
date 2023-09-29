//
//  RecommendedWinesViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 24/09/23.
//
//MARK: INFO
/*Se presenta las diferentes herramientas que se puede ocupar para elegir un vino recomendado ademas de una lista de estos mismos*/

import UIKit

class RecommendedWinesViewController: UIViewController {

    //MARK: definir Outlets del Storyboard
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var starLabel: UILabel!
    @IBOutlet var priceStepper: UIStepper!
    @IBOutlet var starStepper: UIStepper!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var wineTextField: UITextField!
    @IBOutlet var applyWineUIButton: UIButton!
    var winesPickerView2 = UIPickerView() /***Picker view para mostrar los tipos y subtipos de vinos */
    
    
    //MARK: Data para picker View
    //Tipos y subtipos de vinos
    let typeOfWine = ["White Wine", "Red Wine", "Dessert Wine", "Rose Wine", "Sparkling Wine", "Sherry", "Vermouth" ]
    let typeOfWhiteWine = ["Dry White", "Mueller Thurgau", "Grechetto", "Gewurztraminer", "Chenin Blanc", "White Bordeaux", "Semillon", "Riesling", "Sauternes" ]
    let typeOfRedWine = ["Dry Red", "Bordeaux", "Marsala", "Port", "Gamay", "Dornfelder", "Concord Wine", "Pinotage", "Agiorgitiko"]
    let typeOfDessertWine = ["Pedro Ximenez", "Moscato", "Ice Wine", "Madeira", "Banyuls", "Vin Santo"]
    let typeOfRoseWine = ["Sparkling Rose"]
    let typeOfSparklingWine = ["Cava", "Cremant", "Champagne", "Prosecco", "Spumante"]
    let typeOfSherry = ["Cream Sherry", "Dry Sherry"]
    let typeOfVermouth = ["Dry Vermouth"]
    let typeOfDryWhiteWine = ["Cortese", "Muscadet", "Viognier", "Greco", "Marsanne", "Gavi", "Arneis", "Verdejo", "Soave"]
    let typeOfDryRedWine = ["Zweigelt", "Bonarda", "Bairrada", "Tannat", "Corvina", "Rioja", "Malbec", "Carignan", "Shiraz", "Merlot" ]
    
    //MARK: Inicializaciones generales
    var stringTypeOfWine: String = "White Wine" /***Tipo de vino principal */
    var stringTypeOfWhiteOrRedWine: String = "Dry White" /***Sub tipo de vino en caso de ser rojo o blanco */
    var selectedWineString: String = "Cortese" /***Vino que se seleccionara para hacer la busqueda de vinos recomendados*/
    var row: Int = 0 /***Fila de los componentes del picker View*/
    var maxPrice: Int = 50 /***Precio maximo para hacer la busqueda*/
    var minRating: Float = 0.5 /***Raanting minimo para hacer la busqueda de vinos*/
    var recommendedWines = [RecommendedWine]()/***Lista de vinos recomendados que apareceran en la tableview*/
    var dataSource: UITableViewDiffableDataSource<Section,RecommendedWine>!  /***Creara una variable abierta implícitamente para la fuente de datos que usa el tipo de sección que acaba de definir para las secciones que se mostraran en pantalla y el tipo de items que estaran dentro */
    var tableViewImageTasks: [IndexPath : Task<Void, Never>] = [:]/***Arreglo para guardar y borar las Tasks de solicitar imagenes*/
    
    //MARK: Definrir secciones para la tableView
    enum Section: Hashable {
        case wines
    }
    
    //MARK: Actualizaciones de vista
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpPickerView() /***asignar el delegado y dataSource para el pickerView*/
        setUpTextField() /***Asignamos el tipo de entrada y texto*/
        let stringWine = selectedWineString.lowercased().replacingOccurrences(of: " ", with: "_")  /***Si en el nombre del vino existe un espacio esta linea lo sustituye por un  "_" y pone todo en minusculas*/
        requestRecommendedWines(type: stringWine, maxPrice: maxPrice, minRating: minRating) /***Metodo para realizar una solicitud de red para poder recibir vinos recomendados*/
        setUpTableView() /***Actualizamos el tableView como su tableViewLayout, celdas, y delegado*/
        configureTableViewDataSource () /***Configuramos el estilo de dataSourse por ocupar UITableViewDiffableDataSource*/
        configureNavigationItem ()/***Configurar los titulos del navigationItem*/
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tableViewImageTasks.forEach {key, value in value.cancel()} /***Borramos todas las  task de imagenes cuando nos salgamos de esta vista*/
    }
    
    
    //MARK: Configurar la picker view
    func setUpPickerView() {
        //asignar el delegado y dataSource para el pickerView
        winesPickerView2.delegate = self
        winesPickerView2.dataSource = self
    }
    
    //MARK: Configurar el TextField del vino a selecionar
    func setUpTextField() {
        //Asignamos el tipo de entrada y texto
        wineTextField.inputView = winesPickerView2
        wineTextField.text = selectedWineString
    }
    
    //MARK: Solicitud de red para obtener vinos recomendados
    //Esto metodo tambien se llama en caso que los parametros cambien
    func requestRecommendedWines(type: String, maxPrice: Int, minRating: Float){
        let recommendedWinesByType = RecommendedWinesByType(wine: type, maxPrice: String(maxPrice), minRating: String(minRating)) /***Se instancia un objeto que contiene la informacion del tipo de vino a solicitar*/
        Task {
            do {
                let recommendedWines = try await sendRequest(recommendedWinesByType) /***Solicitamos las recetas */
                self.recommendedWines = recommendedWines.recommendedWines /***Se agregan los vinos obtenidos al arreglo que se instancio al inicio de este controlador*/
                //print(self.recommendedWines)
                
                //await dataSource.apply(self.tableSnapshot, animatingDifferences: true) /***Se recarga la vista de dataSource*/
                dataSource.apply(self.tableSnapshot, animatingDifferences: true, completion: { [self] in
                    self.dataSource.apply(self.tableSnapshot, animatingDifferences: false)
                })
            } catch {
                print(error)
            }
        }
        
    }
    
    //MARK: Actualizamos el tableView
    func setUpTableView() {
        //Asignamos el delegado de tableView
        tableView.delegate = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "WinesTableViewCell", bundle: .main), forCellReuseIdentifier: "WinesTVC")
    }
    
    //MARK: Establecer Data Source de tableView
    func configureTableViewDataSource () {
        dataSource = UITableViewDiffableDataSource<Section, RecommendedWine> (tableView: tableView, cellProvider: {
            (tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "WinesTVC", for: indexPath) as! WinesTableViewCell /***Se obtiene la celda para presentar la informacion obtenida*/
            cell.updateCell(wine: item) /***Se usa el metodo updateCell para poder enviar la informacion a la celda y presentarlo */
            let fetchWineImage = FetchWineImage(url: item.imageURL) /***Realizamos una instancia de FetchWineImage para poder realizar un pedido de una imagen del vino*/
            cell.accessoryType = .disclosureIndicator
            self.tableViewImageTasks[indexPath] = Task { /***Creamos una Tak y la gregamos al arreglo para despues borrarla*/
                
                   /*Se obtiene la imagen, pero si es posibke obtenerla se enviara nul, porque no es necesario generar un error al no obtener la imagen.
                    Tambien se obtendra un indexPath con ayuda de la celda y este se comparar a l index que se esta trabajando en tableView(_:, cellForItemAt), esto para que las imagenes se agregen en los indices correctos y no se agregue una imagen en un index diferente
                    */
                if let image = try? await sendRequest(fetchWineImage) {
                    if let currentIndexPath = tableView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        //Se agrega la imagen a la celda
                        cell.wineImageView.image = image
                    }
                }
                self.tableViewImageTasks[indexPath] = nil/***Cancelamos la Task*/
            }
            return cell
            
            
        })
        dataSource.apply(tableSnapshot) /***Aparecer la informacion de las celdas al iniciar la vista***/
    }
    
        
    //MARK: Creaccion del SnapShot para la seccion de vinos
    var tableSnapshot: NSDiffableDataSourceSnapshot<Section,RecommendedWine> {
        var snapshot = NSDiffableDataSourceSnapshot<Section,RecommendedWine>()/***SnapShot vacio*/
        //Instancias la unica sccion de esta vista
        snapshot.appendSections([Section.wines])/***Esta seccion se encuentar arriba de este controlador*/
        snapshot.appendItems(recommendedWines)/***recommendedWines se instancia al inicio y contiene la informacion de los vinos cuando se llamo al metodo requestWines */
        return snapshot
    }
    
    
    //MARK: Acciones para los filtros de la busqueda de vinos
    //Boton para seleccionar el tipo de vino para la busqueda
    @IBAction func applyWineButton(_ sender: UIButton) {
        /*stringTypeOfWine tiene el valor del tipo de vino selecionado y la variable row contine la posicion del subtipo de vino selecionado*/
        switch stringTypeOfWine {
        case "White Wine":
            /*En caso de elegir el subtipo "Dry White" este tiene otro subtipo de vino*/
            if stringTypeOfWhiteOrRedWine == "Dry White" {
                selectedWineString = typeOfDryWhiteWine[row]
            }else {
                selectedWineString = typeOfWhiteWine[row]
            }
        case "Red Wine":
            /*En caso de elegir el subtipo "Dry Red" este tiene otro subtipo de vino*/
            if stringTypeOfWhiteOrRedWine == "Dry Red" {
                selectedWineString = typeOfDryRedWine[row]
            }else {
                selectedWineString = typeOfRedWine[row]
            }
        case "Dessert Wine":
            selectedWineString = typeOfDessertWine[row]
        case "Rose Wine":
            selectedWineString = typeOfRoseWine[row]
        case "Sparkling Wine":
            selectedWineString = typeOfSparklingWine[row]
        case "Sherry":
            selectedWineString = typeOfSherry[row]
        case "Vermouth":
            selectedWineString = typeOfVermouth[row]
        default:
            selectedWineString = ""
        }
        //Se agrega el texto del vino selecionado y descatamosla vista del PickerView
        wineTextField.text = selectedWineString
        wineTextField.resignFirstResponder()
        //print(selectedWineString)
    }
   //Stepper para cambiar el precio maximo del vino
    @IBAction func changePriceStepperValue(_ sender: UIStepper) {
        //Asignamos el valor de precio a la label y ala variable maxPrice
        priceLabel.text = String(sender.value)
        maxPrice = Int(sender.value)
    }
    //Stepper para cambiar el ranting minimo del vino
    @IBAction func changeRatingStarStepperValue(_ sender: UIStepper) {
        //Asignamos el valor de precio a la label y ala variable maxPrice
        starLabel.text = String(sender.value)
        let rating = (sender.value * 2 ) / 10 /***Pasamos de 0 a 5 estrellas a valores de 0.0 a 1.0*/
        minRating = Float(rating)
    }
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Wines"
       
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem (title: "Search Wines", style: .done, target: self, action: #selector(editFilter))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(named: "ColorTeal")!
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Tools", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }
    
    //MARK: Buscar nuevos vinos con nuevos filtros
    @objc func editFilter(){
        let stringWine = selectedWineString.lowercased().replacingOccurrences(of: " ", with: "_")  /***Si en el nombre del vino existe un espacio esta linea lo sustituye por un  "_" y pone todo en minusculas*/
        requestRecommendedWines(type: stringWine, maxPrice: maxPrice, minRating: minRating) /***Metodo para realizar una solicitud de red para poder recibir vinos recomendados*/
    }
    
    //MARK: Ir a la vista respectiva de cada celda al ser presionada
    func goToWineDetailView(wine: RecommendedWine){
        // instanciamos una vista para presentarla
        let wineDetailStoryboard = UIStoryboard(name: "WineDetail", bundle: .main)
        //Instanciamos un ViewController
        if let wineDetailViewController = wineDetailStoryboard.instantiateViewController(withIdentifier: "WineDetailVC") as? WineDetailViewController {
            wineDetailViewController.wineDetail = wine
            navigationController?.pushViewController(wineDetailViewController, animated: true)
        }
    }
    
}


//MARK: Extension para la configuracion del PickerView
extension RecommendedWinesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    //MARK: Configuracion del pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //Determinamos el numero de componentes dependiendo del subtipo de vino
        if stringTypeOfWhiteOrRedWine == "Dry White" || stringTypeOfWhiteOrRedWine == "Dry Red" {
            return 3
        } else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        /*Dependiendo del numero de componente y del tipo de vino selcionado se regresara una cantidad de sub vinos*/
        switch component {
        case 0:
            return typeOfWine.count
        case 1:
            switch stringTypeOfWine {
            case "White Wine":
                return typeOfWhiteWine.count
            case "Red Wine":
                return typeOfRedWine.count
            case "Dessert Wine":
                return typeOfDessertWine.count
            case "Rose Wine":
                return typeOfRoseWine.count
            case "Sparkling Wine":
                return typeOfSparklingWine.count
            case "Sherry":
                return typeOfSherry.count
            case "Vermouth":
                return typeOfVermouth.count
            default:
                return 0
            }
        case 2:
            /*En caso de elegir el subtipo de "Dry White" o "Dry Red" este tendra otros sub tipos de vinos con otra cantidad de vinos a alegir*/
            switch stringTypeOfWhiteOrRedWine {
            case "Dry White":
                return typeOfDryWhiteWine.count
            case "Dry Red":
                return typeOfDryRedWine.count
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        /*Dependiendo del numero de componente y del tipo de vino selcionado se regresara los titulos de los sub vinos*/
        switch component {
        case 0:
            return typeOfWine[row]
        case 1:
            switch stringTypeOfWine {
            case "White Wine":
                return typeOfWhiteWine[row]
            case "Red Wine":
                return typeOfRedWine[row]
            case "Dessert Wine":
                return typeOfDessertWine[row]
            case "Rose Wine":
                return typeOfRoseWine[row]
            case "Sparkling Wine":
                return typeOfSparklingWine[row]
            case "Sherry":
                return typeOfSherry[row]
            case "Vermouth":
                return typeOfVermouth[row]
            default:
                return ""
            }
        case 2:
            /*En caso de elegir el subtipo de "Dry White" o "Dry Red" este tendra otros sub tipos de vinos con otro tipo de titulos de vinos a alegir*/
            switch stringTypeOfWhiteOrRedWine {
            case "Dry White":
                return typeOfDryWhiteWine[row]
            case "Dry Red":
                return typeOfDryRedWine[row]
            default:
                return ""
            }
        default:
            return ""
        }
    }
    
    //MARK: Seleccion de una fila del pickerView
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*Selecionamos el tipo de vino principal y lo asignamos a stringTypeOfWine*/
        if component == 0 {
            stringTypeOfWine = typeOfWine[row]
            //print(stringTypeOfWine)
        }
        /*En caso de elegir el subtipo de vino de "White Wine" o "Red Wine" se asigna el valor a stringTypeOfWhiteOrRedWine*/
        if component == 1 {
            if stringTypeOfWine == "White Wine" {
                stringTypeOfWhiteOrRedWine = typeOfWhiteWine[row]
            } else if stringTypeOfWine == "Red Wine"{
                stringTypeOfWhiteOrRedWine = typeOfRedWine[row]
            }else {
                stringTypeOfWhiteOrRedWine = ""
            }
            //print(stringTypeOfWhiteOrRedWine)
        }
        
        winesPickerView2.reloadAllComponents() /***Cada vez que se eliga un tipo de vino o subtipo de vino se recarga la picker view para mostar los valores respectivos a cada componente con ayuda de las variables stringTypeOfWine y stringTypeOfWhiteOrRedWine*/
        
        //Activamos o desactivamos el boton de aplicar Vino dependiendo la eleccion del picker View
        self.row = row
        if component == 0  || (row == 0 && component == 1 && (stringTypeOfWine == "White Wine" || stringTypeOfWine == "Red Wine")) {
            applyWineUIButton.isEnabled = false
        }else {
            applyWineUIButton.isEnabled = true
        }
    }
}

//MARK: Extension para determinar el delegado de tableView
extension RecommendedWinesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //minimo 120
        return 170 /***Establecemos una altura para cada celda*/
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let wine = recommendedWines[indexPath.row] /***Obtenemos el vino de la celda seleccionada*/
        goToWineDetailView(wine: wine) /***Ir a la nueva vista con la informacion del vino seleccionado*/
    }
    
    //MARK: Borrar la Task de la imagen de la celda que se removio
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewImageTasks[indexPath]?.cancel()
    }
}

