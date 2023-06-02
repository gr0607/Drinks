//
//  FavoritesViewCotroller.swift
//  Drinks
//
//  Created by admin on 24.05.2023.
//

import UIKit
import CoreData

private let reuseID = "FavoriteCell"

class FavoritesViewController: UIViewController {

    //MARK: - Properties
    var drinkViewModel: DrinkViewModel?

    private lazy var tableView: UITableView = {
        var tableView = UITableView()
       // tableView.separatorStyle = .none
        tableView.backgroundColor = .lightBrownBackgroundColor
        tableView.register(FavoriteDrinkCell.self, forCellReuseIdentifier: reuseID)
        return tableView
    }()

    public var coreDataStack: CoreDataStack!

    lazy var fetchedResultController: NSFetchedResultsController<DrinkEntity> = {
        let fetchRequest: NSFetchRequest<DrinkEntity> = DrinkEntity.fetchRequest()
        let dateSort = NSSortDescriptor(key: #keyPath(DrinkEntity.date), ascending: false)
        let likedPredicate = NSPredicate(format: "%K == YES", #keyPath(DrinkEntity.isLiked))
        fetchRequest.sortDescriptors = [dateSort]
        fetchRequest.predicate = likedPredicate

        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: coreDataStack.managedContext,
                                                                 sectionNameKeyPath: nil, cacheName: nil)


        fetchedResultController.delegate = self
        return fetchedResultController
    }()

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupUI()

        do {
          try fetchedResultController.performFetch()
        } catch let error as NSError {
          print("Fetching error: \(error)")
        }
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
        guard let sectionInfo = fetchedResultController.sections?[section] else { return 0}

        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseID,
                                                       for: indexPath) as? FavoriteDrinkCell,
              let favoriteDrink = fetchedResultController.object(at: indexPath) ?? nil
            else {
            return UITableViewCell() }



        cell.configure(with: favoriteDrink)

        return cell
    }

}

//MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let drink = fetchedResultController.object(at: indexPath)
        drinkViewModel?.drinkEntity = drink
        drinkViewModel?.fromFavorites = true
        drinkViewModel?.loadingLogic.toggle()
        tabBarController?.selectedIndex = 0
    }
}

//MARK: - NSFetchedResultsControllerDelegate

extension FavoritesViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}

