//
//  RandomCoctailViewController.swift
//  Coctails
//
//  Created by admin on 28.03.2023.
//

import UIKit

//
//  RandomCoctailViewController.swift
//  Coctails
//
//  Created by admin on 28.03.2023.
//

private let reuseDrinkIdentifier = "DrinkCell"

import UIKit
import SnapKit

class DrinkViewController: UIViewController {

    //MARK: - Properties

    public var drinkViewModel: DrinkViewModel?

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        return searchBar
    }()

    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = drinkViewModel?.drinkName
        label.font = UIFont(name: "Palatino", size: 35)
        label.textColor = .textColor
        return label
    }()

    private lazy var imageCoctail: UIImageView = {
        let imageView = UIImageView()
        imageView.image = drinkViewModel?.drinkImage
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private var instructionNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Instructions:"
        label.font = UIFont(name: "Palatino", size: 25)
        label.textColor = .textColor
        return label
    }()

    private lazy var instructionTextView: UITextView = {
        let tv = UITextView()
        tv.text = drinkViewModel?.drinkInstructions
        tv.font = UIFont(name: "Palatino", size: 20)
        tv.backgroundColor = .lightBrownBackgroundColor
        tv.textColor = .textColor
        return tv
    }()

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .lightBrownBackgroundColor
        tableView.tableHeaderView?.backgroundColor = .lightBrownBackgroundColor
        return tableView
    }()

    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like")!, for: .normal)
        return button
    }()

    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "refresh")!, for: .normal)
        button.addTarget(self, action: #selector(refreshDrink), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, refreshButton])
        stackView.backgroundColor = .lightBrownBackgroundColor
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        return stackView
    }()

    private lazy var drinksCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: view.frame.width, height: 700)
        layout.scrollDirection = .horizontal

        let cv = UICollectionView(frame: .zero , collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(DrinkCell.self, forCellWithReuseIdentifier: reuseDrinkIdentifier)
        return cv
    }()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        drinksCollectionView.dataSource = self
        drinksCollectionView.delegate = self
        setupUI()
    }

    //MARK: - Helpers UI

    func setupUI() {
        view.backgroundColor = .lightBrownBackgroundColor

        navigationController?.navigationBar.barTintColor = .lightBrownBackgroundColor
        navigationItem.titleView = searchBar
  
        view.addSubview(titleLable)
        view.addSubview(imageCoctail)
        view.addSubview(instructionNameLabel)
        view.addSubview(instructionTextView)
        view.addSubview(tableView)
        view.addSubview(stackView)
        view.addSubview(drinksCollectionView)

        makeConstraints()
    }

    func makeConstraints() {
        titleLable.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(120)
        }

        imageCoctail.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.centerX).offset(-16)
            make.height.equalTo(imageCoctail.snp.width)
        }

        instructionNameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.centerX).offset(-8)
        }

        instructionTextView.snp.makeConstraints { make in
            make.top.equalTo(instructionNameLabel.snp.bottom).offset(8)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.centerX).offset(-16)
            make.height.equalTo(180)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLable.snp.bottom).offset(16)
            make.left.equalTo(view.snp.centerX).offset(0)
            make.right.equalTo(view.snp.right).offset(-8)
            make.bottom.equalTo(instructionTextView.snp.bottom)
        }


        stackView.snp.makeConstraints { make in
            make.top.equalTo(imageCoctail.snp.bottom).offset(16)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.centerX).offset(-16)
            make.height.equalTo(60)
        }

        drinksCollectionView.snp.makeConstraints { make in
            make.top.equalTo(instructionTextView.snp.bottom).offset(5)
            make.left.equalTo(view.snp.left).offset(16)
            make.right.equalTo(view.snp.right).offset(-16)
            make.bottom.equalTo(view.snp.bottom).offset(-90)
        }

    }

    //MARK: - Logic
    @objc func refreshDrink() {
        drinkViewModel?.refreshDrink()
        drinkViewModel?.updateScreen = { [weak self] in
            self?.updateUI()
        }
    }

    func updateUI() {
        titleLable.text = drinkViewModel?.drinkName
        imageCoctail.image = drinkViewModel?.drinkImage
        instructionTextView.text = drinkViewModel?.drinkInstructions
        tableView.reloadData()
    }
}

//MARK: - TableViewDataSource

extension DrinkViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return drinkViewModel?.dataSourceFromViewModel.count ?? 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drinkViewModel!.dataSourceFromViewModel[section].0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let text = drinkViewModel?.dataSourceFromViewModel[indexPath.section].1[indexPath.row] ?? "Oops"
        cell.backgroundColor = .lightBrownBackgroundColor
        cell.textLabel?.text = text
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinkViewModel?.dataSourceFromViewModel[section].1.count ?? 0
    }
}

//MARK: - TableViewDelegeta

extension DrinkViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        32
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = .lightBrownBackgroundColor
    }
}

//MARK: - CollectionViewDataSource

extension DrinkViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseDrinkIdentifier, for: indexPath)
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension DrinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
}
