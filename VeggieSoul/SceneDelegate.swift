//
//  SceneDelegate.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 25/05/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    //MARK: Actualizar la insignia de la vista "AccountPage"
    var recipeAndIngredientTabBarItem:  UITabBarItem!
    
    @objc func updateRecipeAndIngredientBadge(){
        /*Agregar el valor de ingredientes y recetas al badgeValue de la vista de AccountPage*/
        if CoreDataRecipe.shared.newRecipes.count != 0 || CoreDataIngredient.shared.newIngredients.count != 0 {
            let numBadgeValue = CoreDataRecipe.shared.newRecipes.count + CoreDataIngredient.shared.newIngredients.count
            recipeAndIngredientTabBarItem.badgeValue = String(numBadgeValue)
        }
    }
    
    func updateNotifications (){
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecipeAndIngredientBadge), name: CoreDataRecipe.recipesUpdateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRecipeAndIngredientBadge), name: CoreDataIngredient.IngredientsUpdateNotification, object: nil)
        recipeAndIngredientTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[2].tabBarItem
    }


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        //MARK: Primer Storyboard
        /*Mencionamos cual sera la primer vista al iniciar la aplicacion*/
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let fristStoryboard = UIStoryboard(name: "RecipeHome", bundle: .main)//Intanciamos el SearchPage como main como el storyboard principal
            if let recipeHomeViewController = fristStoryboard.instantiateViewController(withIdentifier: "TabBarController1") as? UITabBarController { // Instanciamos el TabBarController como la primera vista a presentarse en pantalla
                /**
                 En caso de que la primera vista fuera un ViewController o un TableViewController junto con un navigation controller:
                 let navigationController = UINavigationController(rootViewController: searchPageViewController) // instanciamos un navigation Controller para la primera vista navigationController
                 window.rootViewController = navigationController 
                 */
                
                window.rootViewController = recipeHomeViewController
                self.window = window
                window.makeKeyAndVisible()
            }
            
           
        }
        updateNotifications()/***Actualiza el valor de badgeValue***/
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

