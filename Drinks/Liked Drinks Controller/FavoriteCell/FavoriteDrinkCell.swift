//
//  FavoriteDrinkCell.swift
//  Drinks
//
//  Created by admin on 29.05.2023.
//

import Foundation
import UIKit

class FavoriteDrinkCell: UITableViewCell {

    //MARK: - Properties

    let drinkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        iv.image = #imageLiteral(resourceName: "coctail")
        return iv
    }()

    let drinkNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Coctail"
        label.font = UIFont(name: "Palatino", size: 20)
        label.textColor = .textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var drinkIngridientsLabel: UILabel = {
        let label = UILabel()
        label.text = "Vodka Vodka Vodka"
        label.font = UIFont(name: "Optima", size: 12)
        label.textColor = .textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        return label
    }()
    //MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .lightBrownBackgroundColor
        self.layer.cornerRadius = 10

        addSubview(drinkNameLabel)
        addSubview(drinkImageView)
        addSubview(drinkIngridientsLabel)

        drinkImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90).priority(750)
            make.top.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)

        }

        drinkNameLabel.snp.makeConstraints { make in
            make.left.equalTo(drinkImageView.snp.right).offset(20)
            make.top.equalToSuperview().offset(35)
        }

        drinkIngridientsLabel.snp.makeConstraints { make in
            make.left.equalTo(drinkImageView.snp.right).offset(20)
            make.top.equalTo(drinkNameLabel.snp.bottom)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Helpers methods

    func configure(with favoriteDrink: DrinkEntity) {
        guard let data = favoriteDrink.image, let image = UIImage(data: data) else { return }

        self.drinkImageView.image = image
        self.drinkNameLabel.text = favoriteDrink.name

        let instruction = favoriteDrink.ingridients?.joined(separator: "," ) ?? ""
        self.drinkIngridientsLabel.text = instruction
    }
}
