//
//  ProductViewController.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import UIKit

class ProductDetailViewController: UIViewController {
    var productModel: ProductList
    var imageData: Data?

    var productDetailViewModel = ProductDetailViewModel()

    var homeViewModel: HomeViewModel

    var activityIndicator = CustomActivityIndicator()

    init(productModel: ProductList, data: Data?, homeViewModel: HomeViewModel) {
        self.productModel = productModel
        self.imageData = data
        self.homeViewModel = homeViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating(in: self)
        productDetailViewModel.delegate = self
        layout()
        setupNavBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        productDetailViewModel.getProductDetails(productId: "\(productModel.productID!)")
    }

    lazy var imageView: UIImageView = {
        var image = self.imageData != nil ? UIImage(data: self.imageData!) : UIImage(systemName: "externaldrive.badge.exclamationmark")
        var imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    lazy var brandName: UILabel = {
        var brandName = UILabel()
        brandName.font = .boldSystemFont(ofSize: 18)
        brandName.textColor = .gray
        brandName.textAlignment = NSTextAlignment.center
        brandName.numberOfLines = 0
        return brandName
    }()

    lazy var displayName: UILabel = {
        var displayName = UILabel()
        displayName.font = .boldSystemFont(ofSize: 24)
        displayName.textColor = .black
        displayName.textAlignment = NSTextAlignment.center
        displayName.numberOfLines = 0
        return displayName
    }()

    lazy var price: UILabel = {
        var price = UILabel()
        price.font = .systemFont(ofSize: 16)
        price.textColor = .black
        price.textAlignment = NSTextAlignment.center
        price.numberOfLines = 0
        return price
    }()

    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        return button
    }()

    lazy var details: UILabel = {
        var details = UILabel()
        details.font = .boldSystemFont(ofSize: 16)
        details.textColor = .gray
        details.numberOfLines = 0
        return details
    }()

    @objc func favButtonAction() {
        homeViewModel.isFavorited = !homeViewModel.isFavorited
        if homeViewModel.isFavorited {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}

extension ProductDetailViewController {
    private func setupNavBar() {
        navigationItem.title = "Product Detail"
        navigationController?.setupNavAppearence()
    }

    private func layout() {
        view.addSubview(imageView)
        imageView.setHeight(300)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

        view.addSubview(favoriteButton)
        favoriteButton.setDimensions(height: 40, width: 40)
        favoriteButton.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 4, paddingRight: 4)

        let stackView = UIStackView(arrangedSubviews: [brandName, displayName, price, details])
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.anchor(top: imageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
    }
}

extension ProductDetailViewController: ProductDetailViewModelDelegate {
    func getProductDetail(apiResponse: ApiResponse) {
        if apiResponse == .success {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.details.text = self?.productDetailViewModel.productDetail.result?.description?.özellikler?.replacingOccurrences(of: "<br/>", with: "\n") ?? ""
                self?.price.text = self?.productModel.actualPriceToShowOnScreenText
                self?.displayName.text = self?.productModel.displayName
                self?.brandName.text = self?.productModel.brandName
            }
        }
        if apiResponse == .failed {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
