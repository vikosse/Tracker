//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 12/06/2026.
//

import UIKit

final class CategoryViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: CategoryViewModel

    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.categoryTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var tableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorColor = UIColor.separator
        table.separatorInset = UIEdgeInsets(
            top: 0,
            left: 16,
            bottom: 0,
            right: 16
        )
        table.rowHeight = 75
        table.dataSource = self
        table.delegate = self
        table
            .register(
                CategoryCell.self,
                forCellReuseIdentifier: CategoryCell.reuseIdentifier
            )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Добавить категорию", for: .normal)
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.backgroundColor = .ypBlack
        btn.layer.cornerRadius = 16
        btn
            .addTarget(
                self,
                action: #selector(addButtonTapped),
                for: .touchUpInside
            )
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init

    init(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        addSubviews()
        setupConstraints()
        bindViewModel()
    }

    // MARK: - Private

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(tableView)
        view.addSubview(addButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
            [
                titleLabel.topAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.topAnchor,
                        constant: 27
                    ),
                titleLabel.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor),

                tableContainer.topAnchor
                    .constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                tableContainer.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                tableContainer.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                tableContainer.bottomAnchor
                    .constraint(equalTo: addButton.topAnchor, constant: -24),

                tableView.topAnchor
                    .constraint(equalTo: tableContainer.topAnchor),
                tableView.leadingAnchor
                    .constraint(equalTo: tableContainer.leadingAnchor),
                tableView.trailingAnchor
                    .constraint(equalTo: tableContainer.trailingAnchor),
                tableView.bottomAnchor
                    .constraint(equalTo: tableContainer.bottomAnchor),

                addButton.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 20),
                addButton.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -20),
                addButton.bottomAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                        constant: -16
                    ),
                addButton.heightAnchor.constraint(equalToConstant: 60),
            ]
        )
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        presentNewCategoryScreen()
    }

    private func presentNewCategoryScreen(editingIndex: Int? = nil) {
        let existingTitle = editingIndex.map { viewModel.categoryTitle(at: $0) }
        let newCategoryVC = NewCategoryViewController(
            existingTitle: existingTitle
        )
        newCategoryVC.onComplete = { [weak self, weak newCategoryVC] title in
            if let index = editingIndex {
                self?.viewModel.renameCategory(at: index, to: title)
            } else {
                self?.viewModel.addCategory(titled: title)
            }
            newCategoryVC?.dismiss(animated: true)
        }
        newCategoryVC.modalPresentationStyle = .pageSheet
        present(newCategoryVC, animated: true)
    }

    private func showDeleteConfirmation(at index: Int) {
        let hasTrackers = viewModel.hasTrackers(at: index)
        let alert = UIAlertController(
            title: "Эта категория точно не нужна?",
            message: hasTrackers ? "Все трекеры, находящиеся в данной категории будут удалены" : nil,
            preferredStyle: .actionSheet
        )
        alert
            .addAction(
                UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
                    self?.viewModel.deleteCategory(at: index)
                })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCategories
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CategoryCell.reuseIdentifier,
            for: indexPath
        ) as? CategoryCell else { return UITableViewCell() }

        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == viewModel.numberOfCategories - 1
        let position: CategoryCell.Position = switch (isFirst, isLast) {
        case (true, true): .single
        case (true, false): .first
        case (false, true): .last
        default: .middle
        }

        cell.configure(
            title: viewModel.categoryTitle(at: indexPath.row),
            isSelected: viewModel.isSelected(at: indexPath.row),
            position: position
        )

        cell.separatorInset = isLast
        ? UIEdgeInsets(
            top: 0,
            left: tableView.bounds.width,
            bottom: 0,
            right: 0
        )
        : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension CategoryViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.selectCategory(at: indexPath.row)
    }

    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self else { return UIMenu(title: "", children: []) }

            let edit = UIAction(title: "Редактировать") { [weak self] _ in
                self?.presentNewCategoryScreen(editingIndex: indexPath.row)
            }
            let delete = UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                self?.showDeleteConfirmation(at: indexPath.row)
            }
            return UIMenu(title: "", children: [edit, delete])
        }
    }
}
