//
//  TrackerTypeSelectionViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 18/05/2026.
//

import UIKit

protocol TrackerTypeSelectionDelegate: AnyObject {
    func trackerTypeSelectionDidPickHabit(
        _ controller: HabitTypeSelectionViewController
    )
    func trackerTypeSelectionDidPickIrregularEvent(
        _ controller: HabitTypeSelectionViewController
    )
}

final class HabitTypeSelectionViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: TrackerTypeSelectionDelegate?

    // MARK: - UI Elements

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.trackerCreationTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var habitButton: UIButton = buildButton(
        title: TrackerConstants.habitButtonTitle,
        action: #selector(habitTapped)
    )
    private lazy var irregularEventButton: UIButton = buildButton(
        title: TrackerConstants.irregularEventButtonTitle,
        action: #selector(irregularTapped)
    )

    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            habitButton, irregularEventButton,
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupLayout()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(buttonsStack)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 27
            ),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            buttonsStack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            buttonsStack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            buttonsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            habitButton.heightAnchor.constraint(equalToConstant: 60),
            irregularEventButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }

    private func buildButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }

    // MARK: - Actions

    @objc private func habitTapped() {
        delegate?.trackerTypeSelectionDidPickHabit(self)
    }

    @objc private func irregularTapped() {
        delegate?.trackerTypeSelectionDidPickIrregularEvent(self)
    }
}
