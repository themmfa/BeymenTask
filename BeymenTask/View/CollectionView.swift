import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    var homeViewModel: HomeViewModel
    var navController: UINavigationController

    init(collectionViewLayout: UICollectionViewLayout, homeViewModel: HomeViewModel, navController: UINavigationController) {
        self.homeViewModel = homeViewModel
        self.navController = navController
        super.init(collectionViewLayout: collectionViewLayout)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeViewModel.collectionViewDelegate = self
        collectionView!.register(CustomCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func checkIsFavorite() {
        let allObjects = homeViewModel.getUserDefault() /// When user first open the app, all favorites will be false
        if allObjects == nil || allObjects!.isEmpty {
            for product in homeViewModel.productList.result!.productList! {
                homeViewModel.setRealmObject(productId: String(product.productID!), isFavorite: false)
            }
        } else {
            if homeViewModel.productList.result != nil, homeViewModel.productList.result?.productList != nil, !homeViewModel.productList.result!.productList!.isEmpty {
                let favoriteProducts = homeViewModel.filteredFavorites()
                for (index, product) in homeViewModel.productList.result!.productList!.enumerated() {
                    let x = favoriteProducts?.contains(where: { model in
                        String(product.productID!) == model.productId
                    })
                    if x! {
                        let indexPath = IndexPath(indexes: [0, index])
                        let cell = collectionView.cellForItem(at: indexPath) as? CustomCell
                        cell?.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.productList.result?.productList?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCell
        cell.delegate = self
        homeViewModel.getImageData(url: (homeViewModel.productList.result?.productList![indexPath.row].imageURL)!, cell, for: indexPath)
        checkIsFavorite()
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCell
        let data = cell.imageView.image?.pngData()
        navController.pushViewController(ProductDetailViewController(productModel: (homeViewModel.productList.result?.productList![indexPath.row])!, data: data, homeViewModel: homeViewModel), animated: true)
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return homeViewModel.isFullWidth ? CGSize(width: view.frame.size.width, height: 200) : CGSize(width: view.frame.size.width / 2.3, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let padding: CGFloat = 10
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }
}

extension CollectionViewController: CollectionViewDelegate, CustomCellDelegate {
    func favoriteButtonAction(cell: CustomCell) {
        let indexPath = collectionView.indexPath(for: cell)

        homeViewModel.isFavorited = !homeViewModel.isFavorited
        if homeViewModel.isFavorited {
            homeViewModel.updateRealmObject(index: indexPath!.row, isFavorite: true)
            cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            homeViewModel.updateRealmObject(index: indexPath!.row, isFavorite: false)
            cell.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    func getImageData(apiResponse: ApiResponse, data: Data?, _ cell: CustomCell, for indexPath: IndexPath) {
        let imageCache = NSCache<AnyObject, AnyObject>()

        if apiResponse == .success {
            DispatchQueue.main.async { [weak self] in

                if let imageFromCache = imageCache.object(forKey: cell) as? UIImage {
                    cell.imageView.image = imageFromCache
                    cell.imageView.contentMode = .scaleToFill
                    return
                }
                cell.displayName.text = self?.homeViewModel.productList.result?.productList![indexPath.row].displayName ?? ""
                let imageToCache = UIImage(data: data!)
                imageCache.setObject(imageToCache!, forKey: cell)
                cell.imageView.image = imageToCache
                cell.imageView.contentMode = .scaleToFill
            }
        }
        if apiResponse == .failed {
            // Do nothing
        }
    }
}
