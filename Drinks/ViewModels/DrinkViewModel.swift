//
//  CoctailViewModel.swift
//  Coctails
//
//  Created by admin on 29.03.2023.
//

import Foundation
import UIKit

class DrinkViewModel {

//MARK: - Properties

    var firstDownload: (()->(Void))?
    var firstDownloaded = true
    var updateScreen : (()-> (Void))?
    var reloadCollectionView: (() -> (Void))?



    public var coreDataStack: CoreDataStack!
    public var drinkEntities = [DrinkEntity]()

    public var drink: Drink?

    public var isLiked = false
    public var fromFavorites = false

    public var loadingLogic: Bool = true {
        didSet {
            if !fromFavorites {
                if firstDownloaded {
                    firstDownload?()
                    firstDownloaded = false

                    getEntities()
                } else {
                    updateScreen?()
                    getEntities()
                }
            }
        }
    }

    public var drinkEntity: DrinkEntity?

    public var drinkImage: UIImage?

    public var drinkName: String {
        drink?.name ?? "Coctail"
    }

    public var drinkInstructions: String {
        drink?.instructions ?? ""
    }

    public var drinkImageUrl: String {
        drink?.imageURL ?? ""
    }


//MARK: - Functions

       func fetchDrink() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php")!

        DrinkRequest.shared.execute(url) { coctail in
            self.drink = coctail
            let imageURL = URL(string: coctail!.imageURL)!


            ImageRequest.shared.execute(imageURL) { image in
                self.fromFavorites = false
                self.isLiked = false
                self.drinkImage = image
                self.drinkEntity = self.coreDataStack.saveEntityFrom(drinkViewModel: self)
                self.loadingLogic.toggle()
            }
        }
    }

    func refreshDrink() {
        self.isLiked = false
        fetchDrink()
    }

    func likedDrinkButtonTapped() -> String {
        self.isLiked = true
        coreDataStack.changeEntityFrom(drinkViewModel: self)
        return "Nice choice"
    }

}

//MARK: - Work with CollectionView
extension DrinkViewModel {
    func getCountOfDrinks() -> Int {
        return drinkEntities.count
    }

    func getDrinkEntity(forIndexPath indexPath: IndexPath) -> DrinkEntity {
        return drinkEntities[indexPath.row]
    }

    func getEntities() {
        self.drinkEntities = coreDataStack.getDrinksEntity()
        self.reloadCollectionView?()
    }

}


//MARK: - Helper for Ingridients and Measures

extension DrinkViewModel {
    fileprivate var ingridientsWithoutNil: [String] {
        [drink?.igridientOne, drink?.igridientTwo, drink?.igridientThree, drink?.igridientFour,
         drink?.igridientFive, drink?.igridientSix,drink?.igridientSeven, drink?.igridientEight].compactMap {$0}

    }

    var ingridients: [String] {
        var result = [String]()

        for i in 1...ingridientsWithoutNil.count {
            result.append("\(i). \(ingridientsWithoutNil[i - 1])")
        }
        return result
    }

    fileprivate var measuresWithoutNil: [String] {
        [drink?.measureOne, drink?.measureTwo, drink?.measureThree, drink?.measureFour,
         drink?.measureFive, drink?.measureSix, drink?.measureSeven, drink?.measureEight].compactMap {$0}
    }

    var mesasures: [String] {
        var result = [String]()

        if measuresWithoutNil.count == 0 { return [String]()}

        for i in 1...measuresWithoutNil.count {
            result.append("\(i). \(measuresWithoutNil[i - 1])")
        }
        return result
    }

    var dataSourceFromViewModel: [(String, [String])] {
        [("Ingridients:", drinkEntity?.ingridients ?? [""]), ("Measure:", drinkEntity?.measures ?? [""])]
    }
}
