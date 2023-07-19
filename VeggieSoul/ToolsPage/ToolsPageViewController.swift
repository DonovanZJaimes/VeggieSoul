//
//  ToolsPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 11/07/23.
//

import UIKit
import Lottie
class ToolsPageViewController: UIViewController {

    
    @IBOutlet weak var constructionView: AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAnimationView()
        
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
