//
//  CoreDataRecipe.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 30/08/23.
//

import Foundation
import CoreData

class CoreDataRecipe {
    
    private let container : NSPersistentContainer!
    /***En el inicializador creamos y asignamos un objeto NSPersistentContainer a nuestra propiedad, el argumento corresponde al nombre de nuestro modelo "RecipeVeggieSoul" */
    init() {
        container = NSPersistentContainer(name: "RecipeVeggieSoul", managedObjectModel: PersistenceManager.managedObjectModel)
        //container = NSPersistentContainer(name: "false")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        /***El método loadPersistentStores se encarga de inicializar y completar el Core Data Stack. */
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR \(description) — \(error)")
                return
            } else {
                print("Recipe database ready! ")
            }
        }
    }
    
    
    //MARK: Guardar un nueva receta
    func saveRecipe(recipe: RecipeDetail){
        
        /*para poder interactuar con la base de datos es necesario contar con un NSManagedObjectContext*/
        let context = container.viewContext
          
        /*Creamos un objeto Recipe utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        let Recipe = RecipeEntity(context: context)
        Recipe.id = Int32(recipe.id)
        Recipe.creditURL = recipe.creditURL
        Recipe.credits = recipe.credits
        Recipe.image = recipe.image
        Recipe.isVegetarian = recipe.isVegetarian
        Recipe.likes = Int16(recipe.likes)
        Recipe.minutes = Int16(recipe.minutes)
        Recipe.nameRecipe = recipe.nameRecipe
        Recipe.servings = Int16(recipe.servings)
        
        
        /*Creamos un objeto RecipeIngredient utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        for index in 0 ..< recipe.extendedIngredients.count{
            let RecipeIngredient = RecipeIngredientEntity(context: context)
            RecipeIngredient.id = Int32(recipe.extendedIngredients[index].id)
            RecipeIngredient.image = recipe.extendedIngredients[index].image
            RecipeIngredient.name = recipe.extendedIngredients[index].name
            RecipeIngredient.itsAdded = recipe.extendedIngredients[index].itsAdded ?? false
            RecipeIngredient.measuresUSAmount = recipe.extendedIngredients[index].measures.us.amount
            RecipeIngredient.measuresMetricAmount = recipe.extendedIngredients[index].measures.metric.amount
            RecipeIngredient.measuresUSUnitLong = recipe.extendedIngredients[index].measures.us.unitLong
            RecipeIngredient.measuresUSUnitShort = recipe.extendedIngredients[index].measures.us.unitShort
            RecipeIngredient.measuresMetricUnitLong = recipe.extendedIngredients[index].measures.metric.unitLong
            RecipeIngredient.measuresMetricUnitShort = recipe.extendedIngredients[index].measures.metric.unitShort
            Recipe.addToExtendedIngredients(RecipeIngredient)/***Agregamos un un nuevo ingrediente*/
            RecipeIngredient.belongsToRecipeEntity = Recipe /***Asociamos la RecipeIngredient con la Recipe mediante la propiedad belongsToRecipeEntity*/
            
            
        }
        
        
        /*Creamos un objeto RecipeInstructions utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        if  recipe.instructions?.count != nil {
            for index in 0 ..< recipe.instructions![0].steps.count {
                let RecipeInstructions = RecipeInstructionsEntity(context: context)
                RecipeInstructions.number = Int16(recipe.instructions![0].steps[index].number)
                RecipeInstructions.step = recipe.instructions![0].steps[index].step
                if recipe.instructions![0].steps[index].length != nil {
                    RecipeInstructions.lengthNumber = Int32(recipe.instructions![0].steps[index].length!.number)
                    RecipeInstructions.lengthUnit = recipe.instructions![0].steps[index].length!.unit
                }
                Recipe.addToInstructions(RecipeInstructions) /***Agregamos la nueva instruccion*/
                RecipeInstructions.belongsToRecipeEntity = Recipe /***Asociamos la RecipeInstructions con la Recipe mediante la propiedad belongsToRecipeEntity*/
            }
        }
        
        /*Creamos un objeto RecipeNutrition utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        let RecipeNutrition = RecipeNutritionEntity(context: context)
        RecipeNutrition.weightPerServingAmount = Int32(recipe.nutrition.weightPerServing.amount)
        RecipeNutrition.weightPerServingUnit = recipe.nutrition.weightPerServing.unit
        RecipeNutrition.belongsToRecipeEntity = Recipe /***Asociamos la RecipeNutrition con la Recipe mediante la propiedad belongsToRecipeEntity*/
        
        /*Creamos un objeto RecipeNutritionFlavonoid utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        for index in 0 ..< recipe.nutrition.nutrients.count {
            let RecipeNutritionFlavonoid = RecipeNutritionFlavonoidEntity(context: context)
            RecipeNutritionFlavonoid.amount = recipe.nutrition.nutrients[index].amount
            RecipeNutritionFlavonoid.name = recipe.nutrition.nutrients[index].name
            RecipeNutritionFlavonoid.percentOfDailyNeeds = recipe.nutrition.nutrients[index].percentOfDailyNeeds ?? 0.0
            RecipeNutritionFlavonoid.unit = recipe.nutrition.nutrients[index].unit
            RecipeNutrition.addToNutrients(RecipeNutritionFlavonoid)/***Agregamos una nueva informacion nutricional*/
            RecipeNutritionFlavonoid.belongToRecipeNutritionEntity = RecipeNutrition /***Asociamos la RecipeNutritionFlavonoid con la RecipeNutrition mediante la propiedad belongsToRecipeNutritionEntity*/
        }
        
        
        /*Almacenamos la informacion en la base de datos para ello tenemos que utilizar la función save del NSManagedObjectContext. Esta puede lanzar excepciones por lo que es necesario manejarlo con un try / catch.*/
        do {
            try context.save()
            print("Receta guardada")
        } catch {
             
            print("Error guardando Receta — \(error)")
        }
        
        
    }
    
    
    //MARK: Buscar y regresar todas las recetas
    func fetchRecipes() -> [RecipeEntity] {
        /*Obtenemos un objeto NSFetchRequest mediante la función de clase fetchRequest indicando mediante <> el tipo de objeto que esperamos recibir*/
        let fetchRequest : NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        
        /*Invocamos el método fetch del viewContext del contenedor para obtener un arreglo de Recipes, este bloque puede arrojar una excepción por lo que se debe contemplar dentro de un bloque try/catch*/
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo usuario(s) \(error)")
        }
        
        
        return []
    }
    
   
    
    //MARK: Notificaciones con CoreData
    static let shared = CoreDataRecipe() /***Instancia compartida*/
    static let recipesUpdateNotification = Notification.Name("CoreDataRecipe.recipesUpdate") /***Se crea una notificacion*/
    var newRecipes = [RecipeDetail]() {
        didSet {
            NotificationCenter.default.post(name: CoreDataRecipe.recipesUpdateNotification, object: nil)
        }
    }
}

