//
//  NetworkManager.swift
//  Coctails
//
//  Created by admin on 29.03.2023.
//

import Foundation
import UIKit

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    func decode(_ data: Data) -> ModelType?
    func execute(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void)
}

extension NetworkRequest {
    fileprivate func loadData(_ url: URL, withCompletion completion: @escaping (ModelType?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response , error in
            guard let data = data, let value = self?.decode(data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async { completion(value) }
        }
        task.resume()
    }
}

//MARK: - CoctailRequest

class DrinkRequest: NetworkRequest {
    typealias ModelType = Drink

    static let shared = DrinkRequest()

    private init() { }

    func decode(_ data: Data) -> Drink? {
        let decoder = JSONDecoder()
        let wrappedData = try? decoder.decode(Drinks.self, from: data)
        return wrappedData?.drinks.first
    }

    func execute(_ url: URL, withCompletion completion: @escaping (Drink?) -> Void) {
        loadData(url, withCompletion: completion)
    }
}

//MARK: - ImageRequest

class ImageRequest: NetworkRequest {
    static let shared = ImageRequest()

    private init() { }

    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }

    func execute(_ url: URL, withCompletion completion: @escaping (UIImage?) -> Void) {
        loadData(url, withCompletion: completion)
    }
}
