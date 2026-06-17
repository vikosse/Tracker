//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 07/05/2026.
//

import UIKit

final class StatisticsViewController: UIViewController {

    // MARK: - Properties

    var presenter: StatisticsPresenterProtocol?

    // MARK: - UI Elements

    private lazy var emptyImageView: UIImageView = {
        let imageView = UIImageView(
            image: UIImage(resource: .emptyStatisticsPlaceholder)
        )
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "statistics_empty_title",
            comment: "Текст пустого экрана статистики"
        )
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var emptyStateView: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(emptyImageView)
        container.addSubview(emptyLabel)

        NSLayoutConstraint.activate([
            emptyImageView.centerXAnchor
                .constraint(equalTo: container.centerXAnchor),
            emptyImageView.topAnchor.constraint(equalTo: container.topAnchor),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyLabel.centerXAnchor
                .constraint(equalTo: container.centerXAnchor),
            emptyLabel.topAnchor
                .constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        return container
    }()

    private lazy var bestPeriodCard = StatisticsCardView(
        value: 0,
        title: NSLocalizedString("stat_best_period", comment: "Лучший период")
    )
    private lazy var perfectDaysCard = StatisticsCardView(
        value: 0,
        title: NSLocalizedString("stat_perfect_days", comment: "Идеальные дни")
    )
    private lazy var completedCard = StatisticsCardView(
        value: 0,
        title: NSLocalizedString(
            "stat_trackers_completed",
            comment: "Трекеров завершено"
        )
    )
    private lazy var averageCard = StatisticsCardView(
        value: 0,
        title: NSLocalizedString(
            "stat_average_value",
            comment: "Среднее значение"
        )
    )

    private lazy var statsStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            bestPeriodCard,
            perfectDaysCard,
            completedCard,
            averageCard
        ])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        navigationItem.title = NSLocalizedString(
            "statistics_title",
            comment: "Заголовок экрана статистики"
        )
        navigationController?.navigationBar.prefersLargeTitles = true
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(emptyStateView)
        view.addSubview(statsStackView)

        let cardHeight: CGFloat = 90

        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),

            statsStackView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            statsStackView.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),

            bestPeriodCard.heightAnchor.constraint(equalToConstant: cardHeight),
            perfectDaysCard.heightAnchor
                .constraint(equalToConstant: cardHeight),
            completedCard.heightAnchor.constraint(equalToConstant: cardHeight),
            averageCard.heightAnchor.constraint(equalToConstant: cardHeight)
        ])
    }
}

// MARK: - StatisticsViewProtocol

extension StatisticsViewController: StatisticsViewProtocol {

    func showStatistics(_ data: StatisticsData) {
        bestPeriodCard.configure(value: data.bestPeriod)
        perfectDaysCard.configure(value: data.perfectDays)
        completedCard.configure(value: data.trackersCompleted)
        averageCard.configure(value: data.averageValue)

        emptyStateView.isHidden = true
        statsStackView.isHidden = false
    }

    func showEmptyState() {
        emptyStateView.isHidden = false
        statsStackView.isHidden = true
    }
}
