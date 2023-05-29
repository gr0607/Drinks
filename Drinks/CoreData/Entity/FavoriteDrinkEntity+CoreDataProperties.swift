//
//  FavoriteDrinkEntity+CoreDataProperties.swift
//  Drinks
//
//  Created by admin on 29.05.2023.
//
//

import Foundation
import CoreData


extension FavoriteDrinkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteDrinkEntity> {
        return NSFetchRequest<FavoriteDrinkEntity>(entityName: "FavoriteDrinkEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var favoriteDrink: DrinkEntity?

}

extension FavoriteDrinkEntity : Identifiable {

}
