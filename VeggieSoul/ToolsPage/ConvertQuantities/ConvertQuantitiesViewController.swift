//
//  ConvertQuantitiesViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 24/09/23.
//

import UIKit
import Lottie

class ConvertQuantitiesViewController: UIViewController {

    @IBOutlet var constructionView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnimationView()
    }
    
    
    func setUpAnimationView() {
        constructionView.animation = Animation.named("Construction")
        constructionView.loopMode = .loop
        constructionView.play()
    }

}
