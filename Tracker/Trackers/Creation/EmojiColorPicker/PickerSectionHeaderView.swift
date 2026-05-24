//
//  PickerSectionHeaderView.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import UIKit

final class PickerSectionHeaderView: UICollectionReusableView {

    // MARK: - Properties

    static let reuseIdentifier = "PickerSectionHeader"

    // MARK: - UI Elements

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(title: String) {
        titleLabel.text = title
    }
}
