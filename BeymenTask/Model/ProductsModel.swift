//
//  ProductModel.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import Foundation

// MARK: - Products

struct Products: Decodable {
    let result: Result?

    enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

// MARK: - Result

struct Result: Decodable {
    let productList: [ProductList]?

    enum CodingKeys: String, CodingKey {
        case productList = "ProductList"
    }
}

// MARK: - ProductList

struct ProductList: Decodable {
    let productID: Int?
    let displayName: String?
    let imageURL: String?
    let price: Double?
    let actualPriceToShowOnScreenText: String?
    let brandName: String?

    enum CodingKeys: String, CodingKey {
        case productID = "ProductId"
        case displayName = "DisplayName"
        case imageURL = "ImageUrl"
        case price = "Price"
        case actualPriceToShowOnScreenText = "ActualPriceToShowOnScreenText"
        case brandName = "BrandName"
    }
}
