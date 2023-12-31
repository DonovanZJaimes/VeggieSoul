//
//  RecipeItem.swift
//  VeggieSoul
//
//  Created by Donovan on 12/07/23.
//
//MARK: INFO:
/*Creacion de una enumeracion para las difenetes secciones que se ocuparan en el datasource de "RecipeListByIngredient"*/


import Foundation

enum RecipeItem: Hashable {
    
    //Se tendra dos tipo de secciones, unapara los ingredinetes y otra para las recetas
    case recipeByIngredient(RecipeByIngredient)
    //case recipeByCategory(RecipeByCategory)
    case ingredientRecipeList(IngredientRecipeList)
    
    
    //Propiedad para crear una receta por ingredientes
    var recipeByIngredient: RecipeByIngredient? {
        if case .recipeByIngredient(let recipeByIngredient) = self {
            return recipeByIngredient
        }else{
            return nil
        }
    }
    /*
    var recipeByCategory: RecipeByCategory? {
        if case .recipeByCategory(let recipeByCategory) = self {
            return recipeByCategory
        }else{
            return nil
        }
    }
    */
    
    //Propiede para crear un ingrediente
    var ingredientRecipeList: IngredientRecipeList? {
        if case .ingredientRecipeList(let ingredientRecipeList) = self {
            return ingredientRecipeList
        }else{
            return nil
        }
    }
    
    // Propiedades vacias que nos ayudaran a registrar la informacion de cada seccion de "RecipeListByIngredient"
    static var recipesByIngredient : [RecipeItem] = []
    //static var recipesByCategory : [RecipeItem] = []
    static var ingredientsForRecipeSearch : [RecipeItem] = []
    
    
}
