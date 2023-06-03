//
//  HomeViewModel.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import Foundation
import RealmSwift

enum ApiResponse {
    case success
    case failed
}

protocol HomeViewModelDelegate {
    func getAllProducts(apiResponse: ApiResponse)
}

protocol CollectionViewDelegate {
    func getImageData(apiResponse: ApiResponse, data: Data?, _ cell: CustomCell, for indexPath: IndexPath)
}

class HomeViewModel {
    let delegate: HomeViewModelDelegate
    var collectionViewDelegate: CollectionViewDelegate?
    var isFullWidth: Bool = false
    var isFavorited: Bool = false

    private var apiService = ApiService()
    private var realmService = RealmService()
    var productList: Products = .init(result: nil)

    init(delegate: HomeViewModelDelegate, collectionViewDelegate: CollectionViewDelegate?) {
        self.delegate = delegate
        self.collectionViewDelegate = collectionViewDelegate
    }

    func getUserDefault() -> Results<FavoriteModel>? {
        print(Realm.Configuration().fileURL)
        return realmService.getAllFavorites()
    }

    func setRealmObject(productId: String, isFavorite: Bool) {
        realmService.setFavorite(productId: productId, isFavorite: isFavorite)
    }

    func updateRealmObject(index: Int, isFavorite: Bool) {
        realmService.updateFavorite(index: index, isFavorite: isFavorite)
    }

    func filteredFavorites() -> Results<FavoriteModel>? {
        return realmService.filteredFavorites()
    }

    func getAllProducts() {
        Task {
            do {
                self.productList = try await apiService.getAllProducts()
                delegate.getAllProducts(apiResponse: ApiResponse.success)

            } catch {
                delegate.getAllProducts(apiResponse: ApiResponse.failed)
            }
        }
    }

    func getImageData(url: String, _ cell: CustomCell, for indexPath: IndexPath) {
        Task {
            do {
                let data = try await apiService.downloadImage(from: url)
                collectionViewDelegate?.getImageData(apiResponse: ApiResponse.success, data: data, cell, for: indexPath)

            } catch {
                collectionViewDelegate?.getImageData(apiResponse: ApiResponse.failed, data: nil, cell, for: indexPath)
            }
        }
    }
}
