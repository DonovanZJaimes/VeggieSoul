//
//  CoreDataIngredient.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 21/09/23.
//

import Foundation
import CoreData


class CoreDataIngredient {
    
    private let container : NSPersistentContainer!
    /***En el inicializador creamos y asignamos un objeto NSPersistentContainer a nuestra propiedad, el argumento corresponde al nombre de nuestro modelo "IngredientVeggieSoul" */
    init() {
        container = NSPersistentContainer(name: "Ingredient2VeggieSoul",managedObjectModel: PersistenceManager.managedObjectModel)
        setupDatabase()
    }
    
    private func setupDatabase() {
        /***El método loadPersistentStores se encarga de inicializar y completar el Core Data Stack. */
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR \(description) — \(error)")
                return
            } else {
                print("Ingredient database ready! ")
            }
        }
    }
    
    //MARK: Core Data Saving support
      func save () {
        let context = container.viewContext
        if context.hasChanges {
          do {
              try context.save()
          } catch {
              let nserror = error as NSError
              fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
          }
        }
      }
    
    //MARK: Guardar ingrediente
    func saveIngredient(ingredient: IngredientID, date: Date) {
        /*para poder interactuar con la base de datos es necesario contar con un NSManagedObjectContext*/
        let context = container.viewContext        /*Creamos un objeto Ingredient utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        let Ingredient = IngredientID2Entity(context: context)
        Ingredient.name = ingredient.name
        Ingredient.id = Int64(ingredient.id)
        Ingredient.aisle = ingredient.aisle
        Ingredient.consistency = ingredient.consistency
        Ingredient.image = ingredient.image
        Ingredient.originalName = ingredient.originalName
        Ingredient.percentCarbs = ingredient.nutrition.caloricBreakdown.percentCarbs
        Ingredient.percentFat = ingredient.nutrition.caloricBreakdown.percentFat
        Ingredient.percentProtein = ingredient.nutrition.caloricBreakdown.percentProtein
        Ingredient.unit = ingredient.nutrition.weightPerServing.unit
        Ingredient.amount = Int64(ingredient.nutrition.weightPerServing.amount)
        Ingredient.date = date
        
        
        /*Creamos un objeto IngredientNutrientsEntity utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        for index in 0 ..< ingredient.nutrition.nutrients.count {
            let IngredientNutrients = IngredientNutrients2Entity(context: context)
            IngredientNutrients.amount = ingredient.nutrition.nutrients[index].amount
            IngredientNutrients.name = ingredient.nutrition.nutrients[index].name
            IngredientNutrients.percentOfDailyNeeds = ingredient.nutrition.nutrients[index].percentOfDailyNeeds ?? 0.0
            IngredientNutrients.unit = ingredient.nutrition.nutrients[index].unit
            Ingredient.addToNutrients(IngredientNutrients)/***Agregamos una nueva informacion nutricional*/
            IngredientNutrients.belongsToIngredientID2Entity = Ingredient /***Asociamos el IngredientNutrients con el IngredientNutritionmediante la propiedad belongsToIngredientNutritionEntity*/
        }
        
        
        
        /*Almacenamos la informacion en la base de datos para ello tenemos que utilizar la función save del NSManagedObjectContext. Esta puede lanzar excepciones por lo que es necesario manejarlo con un try / catch.*/
        do {
            try context.save()
            print("Ingrediente guardado")
        } catch {
             
            print("Error guardando Ingrediente — \(error)")
        }
    }
    
    
    //MARK: Buscar y regresar todos los ingredientes
    func fetchIngredients() -> [IngredientID2Entity] {
        /*Obtenemos un objeto NSFetchRequest mediante la función de clase fetchRequest indicando mediante <> el tipo de objeto que esperamos recibir*/
        let fetchRequest : NSFetchRequest<IngredientID2Entity> = IngredientID2Entity.fetchRequest()
        
        /*Invocamos el método fetch del viewContext del contenedor para obtener un arreglo de Ingredientes, este bloque puede arrojar una excepción por lo que se debe contemplar dentro de un bloque try/catch*/
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo ingrediente(s) \(error)")
        }
        
        
        return []
    }
    
    //MARK: Buscar y regresar todos los nutrientes de un ingrediente
    func fetchIngredientNutrients(ingredient: IngredientID2Entity) -> [IngredientNutrients2Entity] {
        //Creamos y configuramos el request para hacer la peticion del arreglo de nutrientes
        let request: NSFetchRequest<IngredientNutrients2Entity> = IngredientNutrients2Entity.fetchRequest()
        request.predicate = NSPredicate(format: "belongsToIngredientID2Entity = %@", ingredient)
        request.sortDescriptors = [NSSortDescriptor(key: "unit", ascending: false)]
        var fetchedNutrients: [IngredientNutrients2Entity] = [] /***Arreglo de nutrientes vacio*/
        do {
            fetchedNutrients = try container.viewContext.fetch(request) /***Arreglo de nutrientes*/
        } catch let error {
            print("Error fetching nutrients \(error)")
        }
        return fetchedNutrients
    }
    
     //MARK: Eliminar todos los ingredientes
    func deleteIngredients(){
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<IngredientID2Entity> = IngredientID2Entity.fetchRequest()
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteBatch)
            print("Delete all Ingredients")
        } catch {
            print("Error Delete all Ingredients \(error)")
        }
    }
    
    //MARK: Eliminar un ingrediente en especifico
    func deleteIngredient(_ ingredient: IngredientID2Entity) {
        let context = container.viewContext
        context.delete(ingredient) /***Eliminamos el ingrediente*/
        save() /***Guardamos los cambios*/
    }
    
    
    //MARK: Notificaciones con CoreData
    static let shared = CoreDataIngredient() /***Instancia compartida*/
    static let IngredientsUpdateNotification = Notification.Name("CoreDataIngredient.ingredientsUpdate") /***Se crea una notificacion*/
    var newIngredients = [IngredientID]() {
        didSet {
            NotificationCenter.default.post(name: CoreDataIngredient.IngredientsUpdateNotification, object: nil)
        }
    }
    
}


