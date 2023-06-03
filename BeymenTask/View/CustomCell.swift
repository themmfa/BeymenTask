//
//  CustomCell.swift
//  BeymenTask
//
//  Created by fe on 2.06.2023.
//

import UIKit

protocol CustomCellDelegate {
    func favoriteButtonAction(cell: CustomCell)
}

class CustomCell: UICollectionViewCell {
    var delegate: CustomCellDelegate?

    @objc func buttonTapped() {
        delegate?.favoriteButtonAction(cell: self)
    }

    override func prepareForReuse() {
        imageView.image = nil
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }

    lazy var displayName: UILabel = {
        var displayName = UILabel()
        displayName.textColor = .black
        displayName.font = .boldSystemFont(ofSize: 16)
        return displayName
    }()

    lazy var imageView: UIImageView = {
        var image = UIImage(systemName: "clock")
        var imageView = UIImageView(image: image)
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 4
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCell {
    private func layout() {
        addSubview(displayName)
        displayName.setHeight(40)
        displayName.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 4, paddingRight: 4)

        addSubview(imageView)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: displayName.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4)

        addSubview(favoriteButton)
        favoriteButton.anchor(top: imageView.topAnchor, right: imageView.rightAnchor, paddingTop: 4, paddingRight: 4)
    }
}
