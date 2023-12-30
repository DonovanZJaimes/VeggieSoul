//
//  CoreDataUsers.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 18/12/23.
//

import Foundation
import CoreData


class CoreDataUsers {
    
    private let container : NSPersistentContainer!
    /***En el inicializador creamos y asignamos un objeto NSPersistentContainer a nuestra propiedad, el argumento corresponde al nombre de nuestro modelo "IngredientVeggieSoul" */
    init() {
        container = NSPersistentContainer(name: "UserVeggieSoul",managedObjectModel: PersistenceManager.managedObjectModel)
        setupDatabase()
    }
    
    private func setupDatabase() {
        /***El método loadPersistentStores se encarga de inicializar y completar el Core Data Stack. */
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("ERROR \(description) — \(error)")
                return
            } else {
                print("Users database ready! ")
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
    
    //MARK: Guardar Usuario
    func saveUser(_ user: UserVS) {
        /*para poder interactuar con la base de datos es necesario contar con un NSManagedObjectContext*/
        let context = container.viewContext        /*Creamos un objeto User utilizando como parámetro el contexto anterior. Asociamos sus propiedades con los parámetros recibidos en el método*/
        
        let User = UserEntity(context: context)
        User.activityQuestion = user.activity
        User.goalQuestion = user.goal
        User.distributionQuestion = user.distribution
        User.name = user.name
        User.age = user.age
        User.gender = user.gender
        User.weight = user.weight
        User.height = user.height
        User.uID = user.uID
        User.calories = user.kCalories
        User.carbohydrates = user.carbohydrates
        User.proteins = user.proteins
        User.fats = user.fats
        
        /*Almacenamos la informacion en la base de datos para ello tenemos que utilizar la función save del NSManagedObjectContext. Esta puede lanzar excepciones por lo que es necesario manejarlo con un try / catch.*/
        do {
            try context.save()
            print("Usuario guardado")
        } catch {
             
            print("Error guardando Usuario — \(error)")
        }
    }
    
    
    //MARK: Buscar y regresar todos los usuarios
    func fetchUsers() -> [UserEntity] {
        /*Obtenemos un objeto NSFetchRequest mediante la función de clase fetchRequest indicando mediante <> el tipo de objeto que esperamos recibir*/
        let fetchRequest : NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        /*Invocamos el método fetch del viewContext del contenedor para obtener un arreglo de Usuarios, este bloque puede arrojar una excepción por lo que se debe contemplar dentro de un bloque try/catch*/
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo usuario(s) \(error)")
        }
        
        
        return []
    }
    
    //MARK: Modificar Usuario
    func modifyUser(withUID uID: UUID, newInformation user: UserVS) {
        let fetchRequest: NSFetchRequest<UserEntity>
        fetchRequest = UserEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "uID = %@", uID as CVarArg )
        fetchRequest.includesPropertyValues = false
        
        let context = container.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                object.activityQuestion = user.activity
                object.goalQuestion = user.goal
                object.distributionQuestion = user.distribution
                object.name = user.name
                object.age = user.age
                object.gender = user.gender
                object.weight = user.weight
                object.height = user.height
                object.calories = user.kCalories
                object.carbohydrates = user.carbohydrates
                object.proteins = user.proteins
                object.fats = user.fats
                //object.uID = user.uID
            }
            
        } catch {
            print("ERROR: \(error)")
        }
        
        do {
            try context.save()
        } catch {
            print("ERROR: \(error)")
        }
        
    }
    
   
    
     //MARK: Eliminar todos los usuarios
    func deleteUsers(){
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let deleteBatch = NSBatchDeleteRequest(fetchRequest: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
        do {
            try context.execute(deleteBatch)
            print("Delete all Users")
        } catch {
            print("Error Delete all Users \(error)")
        }
    }
    
    //MARK: Eliminar un usuario en especifico
    func deleteUser(_ user: UserEntity) {
        let context = container.viewContext
        context.delete(user) /***Eliminamos el ingrediente*/
        save() /***Guardamos los cambios*/
    }
    
}
