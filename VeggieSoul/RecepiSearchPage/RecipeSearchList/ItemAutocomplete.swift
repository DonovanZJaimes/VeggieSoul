//
//  ItemAutocomplete.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 03/07/23.
//
//MARK: INFO:
/*Creacion de una enumeracion para las difenetes secciones que se ocuparan en el datasource de "RecipeSearchList"*/


import Foundation

enum ItemAutocomplete: Hashable {
    //Se tendra dos tipo de secciones, unapara los ingredinetes y otra para las recetas
    case recipe(RecipeAutocomplete)
    case ingredient(IngredientAutocomplete)
    
    //Propiedad para crear una receta
    var recipe: RecipeAutocomplete? {
        if case .recipe(let recipe) = self {
            return recipe
        }else{
            return nil
        }
    }
    //Propiedad para crear un ingrediente
    var ingredient: IngredientAutocomplete? {
        if case .ingredient(let ingredient) = self {
            return ingredient
        }else{
            return nil
        }
    }
    
    
    // Propiedades vacias que nos ayudaran a registrar la informacion de cada seccion de "RecipeHSearchList"
    static var addedIngredients : [ItemAutocomplete] = []
    static var ingredientsToAdd : [ItemAutocomplete] = []
    static var foundRecipes : [ItemAutocomplete] = []
}
