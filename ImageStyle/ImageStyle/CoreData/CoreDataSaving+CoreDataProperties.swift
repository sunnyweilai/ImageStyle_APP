//
//  CoreDataSaving+CoreDataProperties.swift
//  ImageStyle
//
//  Created by Lai Wei on 2021-03-22.
//
//

import Foundation
import CoreData


extension CoreDataSaving {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreDataSaving> {
        return NSFetchRequest<CoreDataSaving>(entityName: "CoreDataSaving")
    }

    @NSManaged public var dayimage: Data?
    @NSManaged public var daydescription: String?
    @NSManaged public var daydate: Date?

}

extension CoreDataSaving : Identifiable {

}
