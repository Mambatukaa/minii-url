//
//  Persistence.swift
//  MiniiURL
//
//  Created by Mambatukaa on 2024.09.04.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()
  let container: NSPersistentContainer
  
  init() {
    
    container = NSPersistentContainer (name: "MiniiURL")
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      
    })
    
    container.viewContext.automaticallyMergesChangesFromParent = true
    
  }
}
