//
//  CoctailViewModel.swift
//  Coctails
//
//  Created by admin on 29.03.2023.
//

import Foundation
import UIKit

class DrinkViewModel {

    var firstDownload: (()->(Void))?
    var firstDownloaded = true
    var updateScreen : (()-> (Void))?

    public var drink: Drink? 

    public var drinkImage: UIImage? {
        didSet {
        if firstDownloaded {
                firstDownload?()
                    firstDownloaded = false
        } else {
                updateScreen?()
            }
        }
    }

    public var drinkName: String {
        drink?.name ?? "Coctail"
    }

    public var drinkInstructions: String {
        drink?.instructions ?? ""
    }

    public var drinkImageUrl: String {
        drink?.imageURL ?? ""
    }

    func fetchDrink() {
        let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/random.php")!

        DrinkRequest.shared.execute(url) { coctail in
            self.drink = coctail
            let imageURL = URL(string: coctail!.imageURL)!


            ImageRequest.shared.execute(imageURL) { image in
                self.drinkImage = image
            }
        }
    }

    func refreshDrink() {
        print("from view model")
        fetchDrink()
    }

}

//MARK: - Ingridients and Measures

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
        [("Ingridients:", ingridients), ("Measure:", mesasures)]
    }
}
