//
//  CoreDataSaving+CoreDataClass.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-22.
//
//

import Foundation
import CoreData

@objc(CoreDataSaving)
final class CoreDataSaving: NSManagedObject,Managed {
    @NSManaged public var daydate: Date?
    @NSManaged public var daydescription: String?
    @NSManaged public var dayimage: Data?
    
    func update(date: Date, dataset: [CoreDataSaving], text: String?, image: Data?)  {
        var inDataset = false
        let context = DayCoreData.shared.container.viewContext
        let dateFormat = DateFormatter.dateAndMonthAndYear
        if dataset.count > 0 {
            for item in dataset {
                guard let itemDate = item.daydate else {
                    return
                }
                if dateFormat.string(from: itemDate)  == dateFormat.string(from: date) {
                    inDataset = true
                }
                if inDataset {
                    item.setValue(text, forKey: "daydescription")
                    item.setValue(image, forKey: "dayimage")
                    DispatchQueue.main.async {
                        self.saveData(context: context)
                    }
                    return
                }
            }
        }
        if !inDataset {
            let newItem : CoreDataSaving = context.insertObject()
            newItem.daydate = date
            newItem.daydescription = text
            newItem.dayimage = image
            DispatchQueue.main.async {
                self.saveData(context: context)
            }
        }
       
    }
    
    private func saveData(context: NSManagedObjectContext) {
        do {
             try context.save()
        } catch  {
            fatalError("\(error)")
        }
    }
    
    static func getDayImage(date: Date, dataset: [CoreDataSaving]) ->Data?{
        var outputImage: Data?
        let dateFormat = DateFormatter.dateAndMonthAndYear
        if dataset.count > 0 {
                for item in dataset {
                    guard let itemDate = item.daydate else {
                        return nil
                    }
                    if dateFormat.string(from: itemDate)  == dateFormat.string(from: date) {
                        guard let image = item.dayimage else {
                            return nil
                        }
                        outputImage = image
                    }
            }
        }
            return outputImage
        
    }
}




protocol Managed: class, NSFetchRequestResult {
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
}

extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
        
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String {
        return entity().name ?? "CoreDataSaving"
    }
}

extension NSManagedObjectContext {
    func insertObject<T: NSManagedObject>() -> T where T: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: self) as? T else { fatalError("error object type")
        }
        return obj
    }
}
