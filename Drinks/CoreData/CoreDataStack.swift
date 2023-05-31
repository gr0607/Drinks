//
//  CoreDataStack.swift
//  Drinks
//
//  Created by admin on 28.05.2023.
//

import Foundation
import CoreData

class CoreDataStack {
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    //MARK: - Init core data code
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("unresolved error \(error)")
            }
        }
        return container
    }()

    func saveContext() {
        guard managedContext.hasChanges else { return }

        do {
            try managedContext.save()
        } catch let nserror as NSError {
            print("unresolved error \(nserror)")
        }
    }


    //MARK: - Work with Entities

     func saveEntityFrom(drinkViewModel: DrinkViewModel) {
        let _ = convertToEntity(from: drinkViewModel)
        saveContext()
    }

    private func saveFavotiteDrink(from drinkViewModel: DrinkViewModel) {
        let favoriteEntity = FavoriteDrinkEntity(context: self.managedContext)
        favoriteEntity.favoriteDrink = convertToEntity(from: drinkViewModel)
        favoriteEntity.date = Date()
        saveContext()
    }

    func convertToEntity(from drinkViewModel: DrinkViewModel) -> DrinkEntity{
        let drinkEntity = DrinkEntity(context: self.managedContext)

        drinkEntity.name = drinkViewModel.drinkName
        drinkEntity.instructions = drinkViewModel.drinkInstructions
        drinkEntity.date = Date()
        drinkEntity.image = drinkViewModel.drinkImage?.pngData()
        drinkEntity.ingridients = drinkViewModel.ingridients
        drinkEntity.measures = drinkViewModel.mesasures
        return drinkEntity
    }

    func getDrinksEntity() -> [DrinkEntity] {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        let dateDecriptor = NSSortDescriptor(key: #keyPath(DrinkEntity.date), ascending: false)
        fetchRequest.sortDescriptors = [dateDecriptor]

        do {
            let results = try self.managedContext.fetch(fetchRequest)
            return results
        } catch let error {
            print(error)
            return [DrinkEntity]()
        }
    }

    func isEntityExist(from drinkViewModel: DrinkViewModel) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteDrinkEntity> = FavoriteDrinkEntity.fetchRequest()
        let namePredicate = NSPredicate(format: "%K == %@", #keyPath(FavoriteDrinkEntity.favoriteDrink.name), drinkViewModel.drinkName)
        fetchRequest.predicate = namePredicate
        do {
            let countResult = try self.managedContext.fetch(fetchRequest)
            if countResult.count != 0 {
                return false
            } else {
                saveFavotiteDrink(from: drinkViewModel)
            }
        } catch let error {
            print(error)
        }
        return true

    }

}
