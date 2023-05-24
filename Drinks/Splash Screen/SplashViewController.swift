//
//  SplashViewController.swift
//  Coctails
//
//  Created by admin on 23.04.2023.
//

import UIKit

class SplashViewController: UIViewController {

    //MARK: - Properties

    private let drinkViewModel = DrinkViewModel()

    private var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "Coctails"
        label.font = UIFont(name: "Palatino", size: 81)
        return label
    }()

    private var loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Loading your drink now..."
        label.textColor = .textColor
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .textColor
        return indicator
    }()

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        drinkViewModel.fetchDrink()
        setupUI()

        drinkViewModel.firstDownload = { [weak self] in
            let vc = DrinkViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            vc.drinkViewModel = self?.drinkViewModel
            self?.present(vc, animated: true)
        }
    }


    //MARK: - Helpers

    func setupUI() {
        view.backgroundColor = .lightBrownBackgroundColor
        navigationController?.navigationBar.isHidden = true

        view.addSubview(mainLabel)
        view.addSubview(loadingLabel)
        view.addSubview(activityIndicator)

        setupConstraints()
        activityIndicator.startAnimating()
    }


    func setupConstraints() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 40),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: loadingLabel.bottomAnchor, constant: 8)
        ])
    }

}
