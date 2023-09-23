//
//  PersistenceManager.swift
//  VeggieSoul
//
//  Created by Donovan Z. Jaimes on 22/09/23.
//

import Foundation
import CoreData
/*Para evitar advertencias al guardar en CoreData: Estas advertencias se debe a que varios modelos de objetos gestionados son la misma subclase de objetos gestionados */
class PersistenceManager {
    let storeName: String! = nil

   /***En NSPersistentContainer solita un NSManagedObjectModel para evitar advertencias*/
    static var managedObjectModel: NSManagedObjectModel = {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: PersistenceManager.self)])!
            return managedObjectModel
        }()

    
}
