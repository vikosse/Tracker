//
//  TrackerCategoryHeaderView.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/06/2026.
//

import UIKit

final class TrackerCategoryHeaderView: UICollectionReusableView {

    static let reuseIdentifier = "TrackerCategoryHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .bold)
        label.textColor = .ypBlack
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor
                .constraint(equalTo: trailingAnchor, constant: -28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    func configure(with title: String) {
        titleLabel.text = title
    }
}
