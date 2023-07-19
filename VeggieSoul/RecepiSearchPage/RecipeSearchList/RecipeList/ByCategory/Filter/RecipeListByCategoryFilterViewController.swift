//
//  RecipeListByCategoryFilterViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/07/23.
//

import UIKit

class RecipeListByCategoryFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let presentationController = presentationController as? UISheetPresentationController else {return}
        presentationController.detents = [.medium()]
        presentationController.selectedDetentIdentifier = .large
        presentationController.prefersGrabberVisible = true
        presentationController.preferredCornerRadius = 30
    }
    


}
