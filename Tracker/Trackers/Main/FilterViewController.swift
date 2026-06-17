//
//  FilterViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/06/2026.
//

import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func filterViewController(_ controller: FilterViewController, didSelectFilter filter: TrackerFilter)
}

final class FilterViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: FilterViewControllerDelegate?
    private let currentFilter: TrackerFilter

    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("filter_title", comment: "Фильтры")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.isScrollEnabled = false
        tv.dataSource = self
        tv.delegate = self
        tv
            .register(
                FilterCell.self,
                forCellReuseIdentifier: FilterCell.reuseIdentifier
            )
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    // MARK: - Init

    init(currentFilter: TrackerFilter) {
        self.currentFilter = currentFilter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupLayout()
    }

    // MARK: - Setup

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)

        let rowHeight: CGFloat = 75
        let totalHeight = rowHeight * CGFloat(TrackerFilter.allCases.count)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor
                .constraint(equalTo: view.topAnchor, constant: 27),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor
                .constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: totalHeight)
        ])
    }
}

// MARK: - UITableViewDataSource

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TrackerFilter.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FilterCell.reuseIdentifier, for: indexPath
        ) as? FilterCell else {
            return UITableViewCell()
        }
        let filter = TrackerFilter.allCases[indexPath.row]
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == TrackerFilter.allCases.count - 1
        cell.configure(
            title: filter.title,
            isSelected: filter == currentFilter,
            isFirst: isFirst,
            isLast: isLast
        )
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let filter = TrackerFilter.allCases[indexPath.row]
        delegate?.filterViewController(self, didSelectFilter: filter)
        dismiss(animated: true)
    }
}

// MARK: - FilterCell

private final class FilterCell: UITableViewCell {
    static let reuseIdentifier = "FilterCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmark: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "checkmark")
        iv.tintColor = .ypBlue
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let backgroundCardView: UIView = {
        let v = UIView()
        v.backgroundColor = .ypBackground
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let separator: UIView = {
        let v = UIView()
        v.backgroundColor = .ypGray
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func setupLayout() {
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(titleLabel)
        backgroundCardView.addSubview(checkmark)
        backgroundCardView.addSubview(separator)

        NSLayoutConstraint.activate(
            [
                backgroundCardView.topAnchor
                    .constraint(equalTo: contentView.topAnchor),
                backgroundCardView.leadingAnchor
                    .constraint(equalTo: contentView.leadingAnchor),
                backgroundCardView.trailingAnchor
                    .constraint(equalTo: contentView.trailingAnchor),
                backgroundCardView.bottomAnchor
                    .constraint(equalTo: contentView.bottomAnchor),

                titleLabel.leadingAnchor
                    .constraint(
                        equalTo: backgroundCardView.leadingAnchor,
                        constant: 16
                    ),
                titleLabel.centerYAnchor
                    .constraint(equalTo: backgroundCardView.centerYAnchor),

                checkmark.trailingAnchor
                    .constraint(
                        equalTo: backgroundCardView.trailingAnchor,
                        constant: -16
                    ),
                checkmark.centerYAnchor
                    .constraint(equalTo: backgroundCardView.centerYAnchor),
                checkmark.widthAnchor.constraint(equalToConstant: 24),
                checkmark.heightAnchor.constraint(equalToConstant: 24),

                separator.leadingAnchor
                    .constraint(
                        equalTo: backgroundCardView.leadingAnchor,
                        constant: 16
                    ),
                separator.trailingAnchor
                    .constraint(
                        equalTo: backgroundCardView.trailingAnchor,
                        constant: -16
                    ),
                separator.bottomAnchor
                    .constraint(equalTo: backgroundCardView.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 0.5)
            ]
        )
    }

    func configure(
        title: String,
        isSelected: Bool,
        isFirst: Bool,
        isLast: Bool
    ) {
        titleLabel.text = title
        checkmark.isHidden = !isSelected
        separator.isHidden = isLast

        var corners: CACornerMask = []
        if isFirst {
            corners.formUnion([.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        if isLast {
            corners.formUnion([.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        }
        backgroundCardView.layer.cornerRadius = (isFirst || isLast) ? 16 : 0
        backgroundCardView.layer.maskedCorners = corners
        backgroundCardView.layer.masksToBounds = true
    }
}
