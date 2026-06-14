//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 14/06/2026.
//

import UIKit

// MARK: - Page model

struct OnboardingPageModel {
    let backgroundImage: UIImage
    let text: String
}

extension OnboardingPageModel {
    static let pages: [OnboardingPageModel] = [
        OnboardingPageModel(
            backgroundImage: UIImage(resource: .onboardingBackground1),
            text: "Отслеживайте только то, что хотите"
        ),
        OnboardingPageModel(
            backgroundImage: UIImage(resource: .onboardingBackground2),
            text: "Даже если это\nне литры воды и йога"
        ),
    ]
}

// MARK: - OnboardingPageViewController

final class OnboardingPageViewController: UIViewController {

    // MARK: - Properties

    private let model: OnboardingPageModel
    private let labelBottomOffset: CGFloat

    // MARK: - UI

    private lazy var backgroundImageView: UIImageView = {
        let iv = UIImageView(image: model.backgroundImage)
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = model.text
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    init(model: OnboardingPageModel, labelBottomOffset: CGFloat) {
        self.model = model
        self.labelBottomOffset = labelBottomOffset
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Private

    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(titleLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
[
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor
                .constraint(equalTo: view.bottomAnchor),

            titleLabel.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor
                .constraint(
                    equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                    constant: -labelBottomOffset
                ),
]
        )
    }
}
