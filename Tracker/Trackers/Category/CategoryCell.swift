//
//  CategoryCell.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 12/06/2026.
//

import UIKit

final class CategoryCell: UITableViewCell {

    // MARK: - Constants

    static let reuseIdentifier = "CategoryCell"

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmarkImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark"))
        iv.tintColor = .ypBlue
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .ypBackground
        selectionStyle = .none

        contentView.addSubview(titleLabel)
        contentView.addSubview(checkmarkImageView)

        NSLayoutConstraint.activate(
[
            titleLabel.leadingAnchor
                .constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor
                .constraint(
                    lessThanOrEqualTo: checkmarkImageView.leadingAnchor,
                    constant: -8
                ),
            titleLabel.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),

            checkmarkImageView.trailingAnchor
                .constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.centerYAnchor
                .constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24),
]
        )
    }

    required init?(coder: NSCoder) { nil }

    // MARK: - Configure

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        checkmarkImageView.isHidden = !isSelected
    }
}
