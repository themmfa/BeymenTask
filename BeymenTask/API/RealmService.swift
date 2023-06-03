//
//  UserDefaultsService.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import RealmSwift

class RealmService {
    let realm = try? Realm()

    func setFavorite(productId: String, isFavorite: Bool) {
        let favorite = FavoriteModel()
        favorite.productId = productId
        favorite.isFavorite = isFavorite
        try! realm?.write {
            realm?.add(favorite)
        }
    }

    func updateFavorite(index: Int, isFavorite: Bool) {
        let favorites = realm?.objects(FavoriteModel.self)
        let favoriteToUpdate = favorites?[index]
        try! realm?.write {
            favoriteToUpdate?.isFavorite = isFavorite
        }
    }

    func getAllFavorites() -> Results<FavoriteModel>? {
        let allFavorites = realm?.objects(FavoriteModel.self)
        return allFavorites
    }

    func filteredFavorites() -> Results<FavoriteModel>? {
        let favorites = realm?.objects(FavoriteModel.self)
        let favorited = favorites?.where {
            $0.isFavorite == true
        }
        return favorited
    }
}
