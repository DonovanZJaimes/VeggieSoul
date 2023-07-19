//
//  RecipeDetailViewController.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//

import UIKit
import Lottie
class RecipeDetailViewController: UIViewController {
    
    var id: Int!
    //MARK: BORRAR
    var name: String!

    @IBOutlet weak var constructionView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimationView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnimationView()
        //print(id)
        
        //print(name)
    }
    
    func setUpAnimationView() {
        constructionView.animation = Animation.named("Construction")
        constructionView.loopMode = .loop
        constructionView.play()
        configureNavigationItem ()/***Comfigura el titulo y botones de navigation item***/
    }
    
    
    
    //MARK: Actualizacion visual extra de la pantalla
    // Funcion que actualiza el color del titulo y los items de la tab bar
    func configureNavigationItem (){
        //Configurar el titulo
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
        navigationItem.title = "Recipe"
       
        //Configurar el boton de edicion
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(doSomething))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }

    //MARK: Editar los filtros
    @objc func doSomething(){
        print("aplicar filtros")
    }

}
