//
//  ToolsPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 11/07/23.
//
//MARK: INFO
/*Se presenta las diferentes herramientas que se puede ocupar al momento de cocinar por medio de una tableView*/

import UIKit
import Lottie

class ToolsPageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let titleTools: [String] = ["Ingredients", "Beverage", "Others"]/***Titulo de las secciones de la tableView*/

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView() /**Configuramos el delegado, data source y la celda*/
        setUpTitle ()/***Configuramos el titulo del navigationItem*/
        
    }
    
    //MARK: Configurar el tableView
    func setUpTableView() {
        //Configuramos el responsable del delagado y dataSource
        tableView.dataSource = self
        tableView.delegate = self
        //Se registra la celda a ocupar
        tableView.register(UINib(nibName: "OptionsToolsPageTableViewCell", bundle: .main), forCellReuseIdentifier: "OptionsToolsPageTVC")
    }
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        navigationItem.title = "TOOLS"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
    }
    
    //MARK: Metodos para ir a su vista respectiva de cada celda
    
    //Ir a la vista de questions
    func goToQuestionsView(){
        // instanciamos una vista para presentarla
        let optionToolStoryboard = UIStoryboard(name: "Questions", bundle: .main)
        //Instanciamos un ViewController
        if let optionToolViewController = optionToolStoryboard.instantiateViewController(withIdentifier: "QuestionsVC") as? QuestionsViewController
        {
            navigationController?.pushViewController(optionToolViewController, animated: true)
        }
    }
    //Ir a la vista de vinos recomendados
    func goToRecommendedWinesView(){
        // instanciamos una vista para presentarla
        let optionToolStoryboard = UIStoryboard(name: "RecommendedWines", bundle: .main)
        //Instanciamos un ViewController
        if let optionToolViewController = optionToolStoryboard.instantiateViewController(withIdentifier: "RecommendedWinesVC") as? RecommendedWinesViewController
        {
            navigationController?.pushViewController(optionToolViewController, animated: true)
        }
    }
    //Ir a la vista de convertir cantidades
    func goToConvertQuantitiesView(){
        // instanciamos una vista para presentarla
        let optionToolStoryboard = UIStoryboard(name: "ConvertQuantities", bundle: .main)
        //Instanciamos un ViewController
        if let optionToolViewController = optionToolStoryboard.instantiateViewController(withIdentifier: "ConvertQuantitiesVC") as? ConvertQuantitiesViewController
        {
            navigationController?.pushViewController(optionToolViewController, animated: true)
        }
    }
    //Ir a la vista de ingrediente sustituto
    func goToSubstituteIngredientView(){
        // instanciamos una vista para presentarla
        let optionToolStoryboard = UIStoryboard(name: "SubstituteIngredient", bundle: .main)
        //Instanciamos un ViewController
        if let optionToolViewController = optionToolStoryboard.instantiateViewController(withIdentifier: "SubstituteIngredientVC") as? SubstituteIngredientViewController
        {
            navigationController?.pushViewController(optionToolViewController, animated: true)
        }
    }
}
//MARK: Extension con metodos del delegado de tableView
extension ToolsPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Index de cada celda
        let substituteIngredientIndexPath = IndexPath(row: 0, section: 0)
        let convertQuantitiesIndexPath = IndexPath(row: 1, section: 0)
        let recommendedWinesIndexPath = IndexPath(row: 0, section: 1)
        let questionsIndexPath = IndexPath(row: 0, section: 2)
        //Ir a una vista dependiendo de la celda seleccionada por medio de su indexPath
        switch indexPath {
        case substituteIngredientIndexPath:
            goToSubstituteIngredientView()
        case convertQuantitiesIndexPath:
            goToConvertQuantitiesView()
        case recommendedWinesIndexPath:
            goToRecommendedWinesView()
        case questionsIndexPath:
            goToQuestionsView()
        default:
            print("")
        }
    
    }
    
}
//MARK: Extension con metodos del dataSource de tableView
extension ToolsPageViewController: UITableViewDataSource {
    //MARK: Se establece la informacion de cada celda
    func numberOfSections(in tableView: UITableView) -> Int {
        toolOptions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        toolOptions[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionsToolsPageTVC", for: indexPath) as! OptionsToolsPageTableViewCell
        let tool = toolOptions[indexPath.section][indexPath.row]
        cell.updateCell(tool)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    //MARK: Se establece la altura de cada celda
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: Se establece el titulo de cada seccion
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titleTools[section]
    }
    
}
