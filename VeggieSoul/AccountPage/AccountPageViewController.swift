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
    private let managerIngredient = CoreDataIngredient() /***Manager para CoreData*/
    var recipeDetail: RecipeDetail! /***Cuando se tenga la informacion de la receta por medio del id se pasara a esta variable */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarItem.badgeValue = "!"
        setUpAnimationView()
        Task {
            do {
                let user = try await submitOrder(parameters: parameters)
                print (user)
            } catch {
                print("ERROR USUARIO")
                print(error)
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpAnimationView()
        saveNewRecipe()
        saveNewIngredient()
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
        //Se eliminan las nuevas agregadas
        CoreDataRecipe.shared.newRecipes.removeAll()
        let recipes = managerRecipe.fetchRecipes()
        print("RECETAS AGREGADAS:")
        recipes.forEach {
            item in
            let name = item.nameRecipe!
            print(name)
            //print(item.date?.formatted())
        }
        /*
        let lastRecipe = recipes.last
        let ingredients = managerRecipe.fetchRecipeIngredients(recipe: lastRecipe!)
        print("INGREDIENTES ULTIMA")
        ingredients.forEach {
            item in
            print(item.name)
        }
        let instructions = managerRecipe.fetchRecipeInstructions(recipe: lastRecipe!)
        print("INSTRUCCIONES ULTIMA")
        instructions.forEach {
            item in
            print(item.number)
        }
        let nutrition = managerRecipe.fetchRecipeNutrition(recipe: lastRecipe!)
        print("NUTRICION ULTIMA")
        print(nutrition.weightPerServingAmount)
        print(nutrition.weightPerServingUnit)
        
        let nutrients = managerRecipe.fetchRecipeNutritionFlavonoid(nutrition: nutrition)
        print("NUTRIENTES ULTIMA")
        nutrients.forEach {
            item in
            print(item.name)
        }
        */
    }
    
    func saveNewIngredient () {
        //Se eliminan los nuevo agregados
        CoreDataIngredient.shared.newIngredients.removeAll()
        let ingredients = managerIngredient.fetchIngredients()
        print("INGREDIENTES AGREGADOS")
        ingredients.forEach{
            item in
            print(item.name!)
            //print(item.date)
        }
        /*
        let lastingredient = ingredients.last
        let nutrients = managerIngredient.fetchIngredientNutrients(ingredient: lastingredient!)
        print("NUTRIENTES INGREDIENTES")
        nutrients.forEach{
            item in
            print(item.name)
        }*/
    }
    
    let baseURL = URL(string: "https://api.spoonacular.com/users/connect")!
    
    let parameters: [String: String] = [
        
            "username": "DonovanZ",
            "firstName": "Donovan",
            "lastName": "Jaimes",
            "email": "donovan133jaimes@gmail.com"
        
    ]
    
    func submitOrder( parameters: [String: String]) async throws -> ConnectUser {
        let orderURL = baseURL
        
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        //request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        /*request.setValue(
            "authToken",
            forHTTPHeaderField: "Authorization"
        )*/
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        
      
        
        //let jsonEncoder = JSONEncoder()
        //let jsonData = try? jsonEncoder.encode(parameters)
        
        let jsonData = try JSONEncoder().encode(parameters)
       
        request.httpBody = jsonData
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw MenuControllerError.orderRequestFailed
        }
        
        let decoder = JSONDecoder()
        let orderResponse = try decoder.decode(ConnectUser.self, from: data)
        return orderResponse
    }
    
    enum MenuControllerError: Error, LocalizedError {
        case orderRequestFailed
    }
    

}

struct ConnectUser: Codable {
    let username, spoonacularPassword, hash: String
}
