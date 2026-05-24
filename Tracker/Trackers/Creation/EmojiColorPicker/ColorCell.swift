//
//  ColorCell.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import UIKit

final class ColorCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "ColorCell"

    // MARK: - UI Elements

    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 0
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        if isSelected {
            contentView.layer.borderWidth = 3
            contentView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
        } else {
            contentView.layer.borderWidth = 0
            contentView.layer.borderColor = nil
        }
    }
}
