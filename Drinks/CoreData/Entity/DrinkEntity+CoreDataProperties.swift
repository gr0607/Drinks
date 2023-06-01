//
//  DrinkEntity+CoreDataProperties.swift
//  Drinks
//
//  Created by admin on 01.06.2023.
//
//

import Foundation
import CoreData


extension DrinkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkEntity> {
        return NSFetchRequest<DrinkEntity>(entityName: "DrinkEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var image: Data?
    @NSManaged public var ingridients: [String]?
    @NSManaged public var instructions: String?
    @NSManaged public var measures: [String]?
    @NSManaged public var name: String?
    @NSManaged public var isLiked: Bool

}

extension DrinkEntity : Identifiable {

}
