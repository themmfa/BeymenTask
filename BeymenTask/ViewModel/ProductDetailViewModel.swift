//
//  ProductDetailViewModel.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import Foundation

protocol ProductDetailViewModelDelegate {
    func getProductDetail(apiResponse: ApiResponse)
}

class ProductDetailViewModel {
    var delegate: ProductDetailViewModelDelegate?
    var productDetail: ProductDetails = .init(result: nil)

    private let apiService = ApiService()

    func getProductDetails(productId: String) {
        Task {
            do {
                self.productDetail = try await apiService.getProductDetail(productId: productId)
                delegate?.getProductDetail(apiResponse: ApiResponse.success)
            } catch {
                delegate?.getProductDetail(apiResponse: ApiResponse.failed)
            }
        }
    }
}
