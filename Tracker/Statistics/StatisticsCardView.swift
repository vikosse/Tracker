//
//  StatisticsCardView.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/06/2026.
//

import UIKit

final class StatisticsCardView: UIView {

    // MARK: - UI Elements

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 34, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gradientLayer = CAGradientLayer()
    private let borderMaskLayer = CAShapeLayer()

    // MARK: - Init

    init(value: Int, title: String) {
        super.init(frame: .zero)
        valueLabel.text = "\(value)"
        titleLabel.text = title
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientBorder()
    }

    // MARK: - Public

    func configure(value: Int) {
        valueLabel.text = "\(value)"
    }

    // MARK: - Private

    private func setupView() {
        backgroundColor = .ypWhite
        layer.cornerRadius = 16
        layer.masksToBounds = false

        gradientLayer.colors = [
            UIColor(resource: .colorSelection01).cgColor,
            UIColor(resource: .colorSelection09).cgColor,
            UIColor(resource: .colorSelection03).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)

        addSubview(valueLabel)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 12),
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            valueLabel.trailingAnchor
                .constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),

            titleLabel.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: 12),
            titleLabel.topAnchor
                .constraint(equalTo: valueLabel.bottomAnchor, constant: 7),
            titleLabel.trailingAnchor
                .constraint(lessThanOrEqualTo: trailingAnchor, constant: -12),
            titleLabel.bottomAnchor
                .constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    private func updateGradientBorder() {
        let cornerRadius: CGFloat = 16
        let borderWidth: CGFloat = 1

        gradientLayer.frame = bounds

        let outerPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        )
        let innerBounds = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        let innerPath = UIBezierPath(
            roundedRect: innerBounds,
            cornerRadius: cornerRadius - borderWidth
        )

        outerPath.append(innerPath)
        outerPath.usesEvenOddFillRule = true

        borderMaskLayer.path = outerPath.cgPath
        borderMaskLayer.fillRule = .evenOdd
        gradientLayer.mask = borderMaskLayer
    }
}

