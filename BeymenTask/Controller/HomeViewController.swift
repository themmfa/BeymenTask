//
//  HomeViewController.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    var collectionViewController: UICollectionViewController?

    private let activityIndicator = CustomActivityIndicator()

    lazy var homeViewModel = HomeViewModel(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        activityIndicator.startAnimating(in: self)
        homeViewModel.getAllProducts()
        collectionViewController = CollectionViewController(collectionViewLayout: UICollectionViewFlowLayout(), homeViewModel: homeViewModel, navController: navigationController!)
        setupNavBar()
        layout()
    }

    override func viewDidAppear(_ animated: Bool) {
        collectionViewController?.collectionView.reloadData()
    }

    private lazy var changeLayoutButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .light, scale: .default)
        button.setImage(UIImage(systemName: "tray.full.fill", withConfiguration: config), for: .normal)
        button.addTarget(self, action: #selector(selectLayout), for: .touchUpInside)
        let profileButton = UIBarButtonItem(customView: button)
        return profileButton
    }()

    @objc func selectLayout() {
        homeViewModel.isFullWidth = !homeViewModel.isFullWidth
        collectionViewController?.collectionView.reloadData()
    }
}

extension HomeViewController {
    private func setupNavBar() {
        navigationItem.title = "Products"
        navigationController?.setupNavAppearence()
        navigationItem.rightBarButtonItem = changeLayoutButton
    }

    private func layout() {
        view.addSubview((collectionViewController?.view)!)
        collectionViewController?.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 500)
        collectionViewController?.view.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 12, paddingRight: 12)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func getAllProducts(apiResponse: ApiResponse) {
        if apiResponse == .success {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                self?.collectionViewController?.collectionView.reloadData()
            }
        }
        if apiResponse == .failed {
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
