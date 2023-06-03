//
//  FavoriteModel.swift
//  BeymenTask
//
//  Created by fe on 3.06.2023.
//

import Foundation
import RealmSwift

import RealmSwift

class FavoriteModel: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var productId: String = ""
    @Persisted var isFavorite: Bool = false
}
