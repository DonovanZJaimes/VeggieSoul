//
//  AccountPageViewController.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 25/05/23.
//

import UIKit
import Lottie
import CoreData

class AccountPageViewController: UIViewController {

    @IBOutlet weak var constructionView: AnimationView!
    
    
    private let managerRecipe = CoreDataRecipe() /***Manager para CoreData*/
    var recipeDetail: RecipeDetail! /***Cuando se tenga la informacion de la receta por medio del id se pasara a esta variable */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarItem.badgeValue = "!"
        setUpAnimationView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnimationView()
        saveNewRecipe()
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
    
    

    
    //MARK: Guardar las nuevas recetas en CoreData
    func saveNewRecipe (){
        //Se guardan las recetas
        for index in 0 ..< CoreDataRecipe.shared.newRecipes.count {
            let recipe = CoreDataRecipe.shared.newRecipes[index]
            managerRecipe.saveRecipe(recipe: recipe)
        }
        
        //Se eliminan las nuevas agregadas
        CoreDataRecipe.shared.newRecipes.removeAll()
        
        let recipes = managerRecipe.fetchRecipes()
        recipes.forEach {
            item in
            print(item.nameRecipe)
        }

    }

}
