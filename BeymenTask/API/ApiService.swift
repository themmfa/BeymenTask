//
//  ApiService.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import UIKit

enum CustomError: Error {
    case badUrl(message: String)
    case badRequest(message: String)
    case invalidData(message: String)
}

class ApiService {
    private let allProductsEndpoint: String = "https://www.beymen.com/Mobile2/api/mbproduct/list?siralama=akillisiralama&sayfa=1&categoryId=10020&includeDocuments=true"
    private let productDetailEndpoint: String = "https://www.beymen.com/Mobile2/api/mbproduct/product?productid="

    func getAllProducts() async throws -> Products {
        guard let url = URL(string: allProductsEndpoint) else {
            throw CustomError.badUrl(message: "Wrong Url")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CustomError.badRequest(message: "Bad request")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Products.self, from: data)
        } catch {
            throw CustomError.invalidData(message: error.localizedDescription)
        }
    }

    func getProductDetail(productId: String) async throws -> ProductDetails {
        guard let url = URL(string: "\(productDetailEndpoint)\(productId)") else {
            throw CustomError.badUrl(message: "Wrong Url")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CustomError.badRequest(message: "Bad request")
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(ProductDetails.self, from: data)
        } catch {
            throw CustomError.invalidData(message: error.localizedDescription)
        }
    }

    func downloadImage(from url: String) async throws -> Data? {
        guard let url = URL(string: url) else {
            throw CustomError.badUrl(message: "Wrong Url")
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw CustomError.badRequest(message: "Bad request")
        }

        return data
    }
}
