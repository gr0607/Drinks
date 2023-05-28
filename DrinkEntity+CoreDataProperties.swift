//
//  DrinkEntity+CoreDataProperties.swift
//  Drinks
//
//  Created by admin on 28.05.2023.
//
//

import Foundation
import CoreData


extension DrinkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkEntity> {
        return NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var instructions: String?
    @NSManaged public var image: Data?
    @NSManaged public var ingridients: [String]?
    @NSManaged public var measures: [String]?
    @NSManaged public var date: Date?

}

extension DrinkEntity : Identifiable {

}
