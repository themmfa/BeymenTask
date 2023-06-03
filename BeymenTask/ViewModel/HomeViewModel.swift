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

class HomeViewModel {
    let delegate: HomeViewModelDelegate
    var isFullWidth: Bool = false
    var isFavorited: Bool = false

    private var apiService = ApiService()
    private var realmService = RealmService()
    var productList: Products = .init(result: nil)

    init(delegate: HomeViewModelDelegate) {
        self.delegate = delegate
    }

    func getUserDefault() -> Results<FavoriteModel>? {
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
}
