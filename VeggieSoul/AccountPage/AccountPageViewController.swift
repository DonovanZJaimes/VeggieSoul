//
//  AccountPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 25/05/23.
//

import UIKit
import Lottie
class AccountPageViewController: UIViewController {

    @IBOutlet weak var constructionView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarItem.badgeValue = "!"
        setUpAnimationView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnimationView()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarItem.badgeValue = nil
    }
    
    
    func setUpAnimationView() {
        constructionView.animation = Animation.named("Construction")
        constructionView.loopMode = .loop
        constructionView.play()
    }

}
