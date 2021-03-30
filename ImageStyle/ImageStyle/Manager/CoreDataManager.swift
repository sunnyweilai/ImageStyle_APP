//
//  CoreDataManager.swift
//  Test
//
//  Created by Lai Wei on 2021-03-29.
//

import Foundation
import CoreData
import SwiftUI
import Combine

class CoreDataManager: NSObject, ObservableObject {
    @Published var willChange = PassthroughSubject<Void, Never>()
    
    var savingData = [CoreDataSaving]() {
        willSet {
            willChange.send()
        }
    }
    
    fileprivate var fetchResultsController: NSFetchedResultsController<CoreDataSaving>
    
    override init() {
        let request = CoreDataSaving.sortedFetchRequest
        request.fetchBatchSize = 20
        request.returnsObjectsAsFaults = false
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DayCoreData.shared.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        fetchResultsController.delegate = self
        
        try! fetchResultsController.performFetch()
        savingData = fetchResultsController.fetchedObjects!
        
    }
    
    
}

extension CoreDataManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        savingData = controller.fetchedObjects as! [CoreDataSaving]
    }
}
