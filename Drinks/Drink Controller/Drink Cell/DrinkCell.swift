//
//  DrinkCell.swift
//  Coctails
//
//  Created by admin on 23.05.2023.
//

import UIKit

class DrinkCell: UICollectionViewCell {

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
        label.text = "Coct"
        label.font = UIFont(name: "Palatino", size: 15)
        label.textColor = .textColor
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightBrownBackgroundColor
        self.layer.cornerRadius = 10

        addSubview(drinkNameLabel)
        addSubview(drinkImageView)

        drinkImageView.snp.makeConstraints { make in
            make.height.width.equalTo(90)
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }

        drinkNameLabel.snp.makeConstraints { make in
            make.top.equalTo(drinkImageView.snp.bottom).offset(8)
            make.centerX.bottom.left.right.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureCell(with entity: DrinkEntity) {
        guard let data = entity.image, let image = UIImage(data: data) else { return }

        self.drinkImageView.image = image
        self.drinkNameLabel.text = entity.name
    }
    
}
