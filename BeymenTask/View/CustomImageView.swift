//
//  CustomImageView.swift
//  BeymenTask
//
//  Created by fe on 3.06.2023.
//

import UIKit

class CustomImageView: UIImageView {
    var homeViewModel: HomeViewModel

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }

    func loadImage(ur: String) {
        homeViewModel.getImageData(url: <#T##String#>, <#T##cell: CustomCell##CustomCell#>, for: <#T##IndexPath#>)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
