//
//  WineDetailViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 27/09/23.
//
//MARK: INFO
/*Se presenta la descripcion del vino selecionado ademas de un link para poder acceder a una pagina de compra*/

import UIKit
import SafariServices

class WineDetailViewController: UIViewController {

    @IBOutlet var descriptionWineLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    var wineDetail: RecommendedWine!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTitle () /***Configuramos el titulo del navigationItem*/
        setUpView() /***Configuramos  los detalles de la vista general*/
    }
    
    //MARK: Configuramos  los detalles de la vista general
    func setUpView() {
        titleLabel.text = wineDetail.title
        descriptionWineLabel.text = wineDetail.description
    }
    
    
    //MARK: Configurar titulo y los items de la tab bar
    func setUpTitle (){
        //Titulo
        navigationItem.title = "Description"
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "ColorTeal")!]
        navigationItem.standardAppearance = appearance
       //TabBar
        self.tabBarController?.tabBar.tintColor = UIColor(named: "ColorTeal")
        
        //Configurar el boton de backBarButtonItem
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem (title: "Wines", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .darkGray
    }

    //MARK: Boton para acceder a la pagina de compra
    @IBAction func gotoPurchaseLinkButton(_ sender: UIButton) {
        guard let url = URL(string: wineDetail.link) else {return}
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.popoverPresentationController?.sourceView = sender
        present(safariViewController, animated: true)
    }
    

}
