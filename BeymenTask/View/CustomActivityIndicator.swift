//
//  CustomActivityIndicator.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//
import UIKit

class CustomActivityIndicator: UIViewController {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.center = view.center
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        view.addSubview(activityIndicator)
    }

    func startAnimating(in viewController: UIViewController) {
        modalPresentationStyle = .overFullScreen
        viewController.present(self, animated: false, completion: nil)
        activityIndicator.startAnimating()
    }

    func stopAnimating() {
        activityIndicator.stopAnimating()
        dismiss(animated: false, completion: nil)
    }
}
