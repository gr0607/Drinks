//
//  Coctail.swift
//  Coctails
//
//  Created by admin on 29.03.2023.
//

import Foundation
import UIKit

struct Drinks: Decodable{
    let drinks: [Drink]
}

struct Drink {
    let id: String
    let name: String
    let category: String
    let alcoholic: String
    let glass: String
    let instructions: String
    let imageURL: String

  //TODO: - Can Improve?
    let igridientOne: String?
    let igridientTwo: String?
    let igridientThree: String?
    let igridientFour: String?
    let igridientFive: String?
    let igridientSix: String?
    let igridientSeven: String?
    let igridientEight: String?

    let measureOne: String?
    let measureTwo: String?
    let measureThree: String?
    let measureFour: String?
    let measureFive: String?
    let measureSix: String?
    let measureSeven: String?
    let measureEight: String?
}

extension Drink: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "idDrink"
        case name = "strDrink"
        case category = "strCategory"
        case alcoholic = "strAlcoholic"
        case glass = "strGlass"
        case instructions = "strInstructions"
        case imageURL = "strDrinkThumb"

        case igridientOne = "strIngredient1"
        case igridientTwo = "strIngredient2"
        case igridientThree = "strIngredient3"
        case igridientFour = "strIngredient4"
        case igridientFive = "strIngredient5"
        case igridientSix = "strIngredient6"
        case igridientSeven = "strIngredient7"
        case igridientEight = "strIngredient8"

        case measureOne = "strMeasure1"
        case measureTwo = "strMeasure2"
        case measureThree = "strMeasure3"
        case measureFour = "strMeasure4"
        case measureFive = "strMeasure5"
        case measureSix = "strMeasure6"
        case measureSeven = "strMeasure7"
        case measureEight = "strMeasure8"
    }
}
