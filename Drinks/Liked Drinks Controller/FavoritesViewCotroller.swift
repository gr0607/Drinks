//
//  FavoritesViewCotroller.swift
//  Drinks
//
//  Created by admin on 24.05.2023.
//

import UIKit

private let reuseID = "FavoriteCell"

class FavoritesViewController: UIViewController {

    //MARK: - Properties
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
       // tableView.separatorStyle = .none
        tableView.backgroundColor = .lightBrownBackgroundColor
        tableView.register(FavoriteDrinkCell.self, forCellReuseIdentifier: reuseID)
        return tableView
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()
    }

    //MARK: - Helper Function
    func setupUI() {
        navigationController?.navigationBar.barTintColor = .lightBrownBackgroundColor
        view.backgroundColor = .lightBrownBackgroundColor
        title = "Favorites Coctails"

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                       for: indexPath) as? FavoriteDrinkCell
        else { return UITableViewCell() }
        return cell
    }

}

//MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {

}
