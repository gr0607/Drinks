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

    func saveEntityFrom(drinkViewModel: DrinkViewModel) -> DrinkEntity{
        let entity = convertToEntity(from: drinkViewModel)
        saveContext()
        return entity
    }

    func changeEntityFrom(drinkViewModel: DrinkViewModel) {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(DrinkEntity.name), drinkViewModel.drinkName)
        fetchRequest.predicate = predicate

        do {
            let results = try self.managedContext.fetch(fetchRequest)
            let entity = results.first
            entity?.isLiked = drinkViewModel.isLiked
            saveContext()
        } catch let err {
            print("Error in changing \(err)")
        }
    }

    func convertToEntity(from drinkViewModel: DrinkViewModel) -> DrinkEntity{
        let drinkEntity = DrinkEntity(context: self.managedContext)

        drinkEntity.name = drinkViewModel.drinkName
        drinkEntity.isLiked = drinkViewModel.isLiked
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

    func isFavoriteEntityExist(from drinkViewModel: DrinkViewModel, with name: String) -> Bool {
        let fetchedRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        if isEntityExist(from: drinkViewModel, in: fetchedRequest, with: name) {
            return true
        } else {
            print("DEBUG favofirte save")
            saveEntityFrom(drinkViewModel: drinkViewModel)
            return false
        }
    }

    func isEntityExist<T: NSFetchRequestResult>(from drinkViewModel: DrinkViewModel,in request: NSFetchRequest<T>, with name: String ) -> Bool{
        
        let namePredicate = NSPredicate(format: "%K == %@", name, drinkViewModel.drinkName)
        request.predicate = namePredicate
        do {
            let countResult = try self.managedContext.fetch(request)
            if countResult.count != 0 {
                return true
            }
        } catch let error {
            print(error)
        }
        return false
    }

    

}
