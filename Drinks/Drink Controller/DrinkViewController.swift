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

    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.text = drinkViewModel?.drinkEntity?.name
        label.font = UIFont(name: "Palatino", size: 35)
        label.textColor = .textColor
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private lazy var imageCoctail: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(data: (drinkViewModel?.drinkEntity?.image!)!)
        imageView.image = image
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
        tv.text = drinkViewModel?.drinkEntity?.instructions
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
        button.addTarget(self, action: #selector(likedDrinkButtonTapped), for: .touchUpInside)
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
        cv.backgroundColor = .lightBrownBackgroundColor
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    //MARK: - Helpers UI

    func setupUI() {
        view.backgroundColor = .lightBrownBackgroundColor

        navigationController?.navigationBar.barTintColor = .lightBrownBackgroundColor
        navigationController?.navigationBar.isHidden = true

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
        showLoadingView()
        drinkViewModel?.refreshDrink()
        drinkViewModel?.updateScreen = { [weak self] in
            self?.updateUI()
        }

        drinkViewModel?.reloadCollectionView = {
            self.drinksCollectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
    }

    @objc func likedDrinkButtonTapped() {
       let message = drinkViewModel?.likedDrinkButtonTapped()
       showToast(message: message, font: UIFont.italicSystemFont(ofSize: 14))
    }

    func updateUI() {
        titleLable.text = drinkViewModel?.drinkEntity?.name
        let image = UIImage(data: (drinkViewModel?.drinkEntity?.image!)!)
        imageCoctail.image = image
        instructionTextView.text = drinkViewModel?.drinkEntity?.instructions
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
        return drinkViewModel?.getCountOfDrinks() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseDrinkIdentifier, for: indexPath) as? DrinkCell,
              let entity = drinkViewModel?.getDrinkEntity(forIndexPath: indexPath)
              else { return UICollectionViewCell()}

        cell.configureCell(with: entity)

        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension DrinkViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}

//MARK: - ShowToast

extension UIViewController {
    
    func showToast(message : String?, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 125, y: self.view.frame.size.height-self.view.frame.size.height / 2, width: 250, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: - Show Loading View

extension DrinkViewController {
    func showLoadingView() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)

        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();

        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
}
