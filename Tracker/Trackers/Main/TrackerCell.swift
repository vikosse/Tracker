//
//  TrackerCell.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 20/05/2026.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapActionButton(in cell: TrackerCell)
}

final class TrackerCell: UICollectionViewCell {
    
    // MARK: - Nested Types
    
    private enum ActionIcon {
        case completed
        case notCompleted
        
        var symbolName: String {
            switch self {
            case .completed:
                return "checkmark"
            case .notCompleted:
                return "plus"
            }
        }
    }
    
    // MARK: - Properties
    
    static let reuseIdentifier = "TrackerCell"
    weak var delegate: TrackerCellDelegate?
    
    // MARK: - UI Elements
    
    private let colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        label.baselineAdjustment = .alignCenters
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupLayout()
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        contentView.addSubview(colorView)
        
        colorView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        
        colorView.addSubview(nameLabel)
        
        contentView.addSubview(counterLabel)
        contentView.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.topAnchor.constraint(
                greaterThanOrEqualTo: emojiBackgroundView.bottomAnchor,
                constant: 8
            ),
            
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            counterLabel.centerYAnchor.constraint(equalTo: actionButton.centerYAnchor),
            
            actionButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionButton.widthAnchor.constraint(equalToConstant: 34),
            actionButton.heightAnchor.constraint(equalToConstant: 34),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Configure
    
    func configure(with tracker: Tracker, isCompleted: Bool, completedCount: Int, isButtonEnabled: Bool) {
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color
        nameLabel.text = tracker.name
        counterLabel.text = Self.pluralDays(completedCount)
        
        actionButton.backgroundColor = tracker.color
        
        let state: ActionIcon = isCompleted ? .completed : .notCompleted
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold)
        actionButton.setImage(UIImage(systemName: state.symbolName, withConfiguration: config), for: .normal)
        
        actionButton.isEnabled = isButtonEnabled
        actionButton.alpha = (isCompleted || !isButtonEnabled) ? 0.3 : 1.0
    }
    
    @objc private func actionButtonTapped() {
        delegate?.didTapActionButton(in: self)
    }
    
    // MARK: - Pluralization

    static func pluralDays(_ count: Int) -> String {
        String(format: NSLocalizedString("tracker_completed_days", comment: "Количество дней выполнения трекера"), count)
    }
}
