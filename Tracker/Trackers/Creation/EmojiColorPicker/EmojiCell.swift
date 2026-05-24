//
//  EmojiCell.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import UIKit

final class EmojiCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseIdentifier = "EmojiCell"

    // MARK: - UI Elements

    private let selectionBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectionBackgroundView)
        selectionBackgroundView.addSubview(emojiLabel)

        NSLayoutConstraint.activate([
            selectionBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectionBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectionBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectionBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            emojiLabel.centerXAnchor.constraint(equalTo: selectionBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: selectionBackgroundView.centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure

    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        selectionBackgroundView.backgroundColor = isSelected ? .ypLightGray : .clear
    }
}
