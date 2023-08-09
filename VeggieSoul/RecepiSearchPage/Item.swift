//
//  Item.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 01/07/23.
//
//MARK: INFO:
/*Creacion de una enumeracion para las difenetes secciones que se ocuparan en el datasource de "RecipeHome"*/


import Foundation
enum Item: Hashable {
    //Se tendra dos tipo de secciones, unapara los ingredinetes y otra para las recetas
    case recipe(Recipe)
    case ingredient(Ingredient)
    
    //Propiedad para crear una receta
    var recipe: Recipe? {
        if case .recipe(let recipe) = self {
            return recipe
        }else{
            return nil
        }
    }
    //Propiede para crear un ingrediente
    var ingredient: Ingredient? {
        if case .ingredient(let ingredient) = self {
            return ingredient
        }else{
            return nil
        }
    }
    
    // Propiedades vacias que nos ayudaran a registrar la informacion de cada seccion de "RecipeHome"
    static var saladRecipes : [Item] = []
    static var soupRecipes : [Item] = []
    static var breakfastRecipes : [Item] = []
    static var mainCourseRecipes : [Item] = []
    static var beverageRecipes : [Item] = []
    static var appetizerRecipes : [Item] = []
    static var dessertRecipes : [Item] = []
    
    static var firstIngredients : [Item] = []
    
    
}
