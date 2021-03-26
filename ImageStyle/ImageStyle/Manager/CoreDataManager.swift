//
//  CoreDataManager.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-22.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    
    static let shared = CoreDataManager()
     let container: NSPersistentContainer = {
          let container = NSPersistentContainer(name: "CoreDataSaving")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()
}
