//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 10/05/2026.
//

import UIKit

final class TrackersViewController: UIViewController {

    // MARK: - Properties

    var presenter: TrackersPresenterProtocol?

    // MARK: - UI Elements

    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = TrackerConstants.supportedLocale
        picker
            .addTarget(
                self,
                action: #selector(dateChanged(_:)),
                for: .valueChanged
            )

        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.widthAnchor.constraint(equalToConstant: 100).isActive = true

        return picker
    }()

    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = TrackerConstants.searchPlaceholderText
        bar.searchBarStyle = .minimal
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()

    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [placeholderImageView, placeholderLabel]
        )
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(
            top: 12,
            left: 16,
            bottom: 16,
            right: 16
        )

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 60,
            right: 0
        )

        collectionView
            .register(
                TrackerCell.self,
                forCellWithReuseIdentifier: TrackerCell.reuseIdentifier
            )
        collectionView.register(
            TrackerCategoryHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCategoryHeaderView.reuseIdentifier
        )
        return collectionView
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button
            .setTitle(
                NSLocalizedString("filter_title", comment: "Фильтры"),
                for: .normal
            )
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.backgroundColor = .ypBlue
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button
            .addTarget(
                self,
                action: #selector(filterButtonTapped),
                for: .touchUpInside
            )
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupNavigationBar()
        setupSearchBar()
        setupCollectionView()
        setupPlaceholder()
        setupFilterButton()

        presenter?.viewDidLoad()
        MainScreenAnalytics.open()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MainScreenAnalytics.close()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.title = TrackerConstants.trackersTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
        addButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = addButton

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            customView: datePicker
        )
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate(
            [
                searchBar.topAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.topAnchor,
                        constant: 8
                    ),
                searchBar.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 8),
                searchBar.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -8)
            ]
        )
    }

    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor
                .constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor
                .constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor
                .constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupPlaceholder() {
        view.addSubview(placeholderStackView)
        NSLayoutConstraint.activate([
            placeholderStackView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor
                .constraint(equalTo: view.centerYAnchor),

            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupFilterButton() {
        view.addSubview(filterButton)
        NSLayoutConstraint.activate(
            [
                filterButton.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor),
                filterButton.bottomAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                        constant: -16
                    ),
                filterButton.widthAnchor.constraint(equalToConstant: 114),
                filterButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
        filterButton.isHidden = true
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        MainScreenAnalytics.tapAddTrack()
        presenter?.didTapAddButton()
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        presenter?.didChangeDate(sender.date)
        if let presented = presentedViewController,
           presented.modalPresentationStyle == .popover {
            presented.dismiss(animated: true)
        }
    }

    @objc private func filterButtonTapped() {
        MainScreenAnalytics.tapFilter()
        let filterVC = FilterViewController(
            currentFilter: presenter?.currentFilter ?? .all
        )
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .pageSheet
        if let sheet = filterVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(filterVC, animated: true)
    }
}

// MARK: - FilterViewControllerDelegate

extension TrackersViewController: FilterViewControllerDelegate {
    func filterViewController(
        _ controller: FilterViewController,
        didSelectFilter filter: TrackerFilter
    ) {
        presenter?.didSelectFilter(filter)
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func didTapActionButton(in cell: TrackerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        MainScreenAnalytics.tapTrack()
        presenter?.didTapTrackerAction(at: indexPath)
    }
}

// MARK: - TrackersViewProtocol

extension TrackersViewController: TrackersViewProtocol {
    func showEmptyDayPlaceholder() {
        placeholderImageView.image = UIImage(resource: .trackersPlaceholder)
        placeholderLabel.text = TrackerConstants.emptyTrackerScreenTitle
        placeholderStackView.isHidden = false
        collectionView.isHidden = true
    }

    func showNotFoundPlaceholder() {
        placeholderImageView.image = UIImage(resource: .notFoundPlaceholder)
        placeholderLabel.text = NSLocalizedString(
            "filter_not_found_title",
            comment: "Ничего не найдено"
        )
        placeholderStackView.isHidden = false
        collectionView.isHidden = true
    }

    func hidePlaceholder() {
        placeholderStackView.isHidden = true
        collectionView.isHidden = false
    }

    func reloadTrackers() {
        collectionView.reloadData()
    }

    func presentTrackerCreation() {
        let typeSelectionVC = HabitTypeSelectionViewController()
        typeSelectionVC.delegate = self
        typeSelectionVC.modalPresentationStyle = .pageSheet
        present(typeSelectionVC, animated: true)
    }

    func showFilterButton() {
        filterButton.isHidden = false
    }

    func hideFilterButton() {
        filterButton.isHidden = true
    }

    func updateCurrentDate(_ date: Date) {
        datePicker.date = date
    }

    func presentTrackerEdit(
        tracker: Tracker,
        categoryTitle: String,
        completedDays: Int
    ) {
        let editVC: UIViewController
        if tracker.schedule.isEmpty {
            let vc = IrregularEventCreationViewController(
                editingTracker: tracker,
                categoryTitle: categoryTitle,
                completedDays: completedDays
            )
            vc.delegate = self
            editVC = vc
        } else {
            let vc = HabitCreationViewController(
                editingTracker: tracker,
                categoryTitle: categoryTitle,
                completedDays: completedDays
            )
            vc.delegate = self
            editVC = vc
        }
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }

    func showDeleteConfirmation(onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString(
                "delete_tracker_confirmation",
                comment: "Подтверждение удаления трекера"
            ),
            preferredStyle: .actionSheet
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString(
                "delete_action_title",
                comment: "Удалить"
            ),
            style: .destructive
        ) { _ in onConfirm() })
        alert.addAction(UIAlertAction(
            title: TrackerConstants.cancelButtonTitle,
            style: .cancel
        ))
        present(alert, animated: true)
    }
}

// MARK: - TrackerTypeSelectionDelegate

extension TrackersViewController: TrackerTypeSelectionDelegate {
    func trackerTypeSelectionDidPickHabit(
        _ controller: HabitTypeSelectionViewController
    ) {
        controller.dismiss(animated: true) { [weak self] in
            self?.presentHabitCreation()
        }
    }

    func trackerTypeSelectionDidPickIrregularEvent(
        _ controller: HabitTypeSelectionViewController
    ) {
        controller.dismiss(animated: true) { [weak self] in
            self?.presentIrregularEventCreation()
        }
    }

    private func presentHabitCreation() {
        let habitVC = HabitCreationViewController()
        habitVC.delegate = self
        habitVC.modalPresentationStyle = .pageSheet
        present(habitVC, animated: true)
    }

    private func presentIrregularEventCreation() {
        let irregularVC = IrregularEventCreationViewController()
        irregularVC.delegate = self
        irregularVC.modalPresentationStyle = .pageSheet
        present(irregularVC, animated: true)
    }
}

// MARK: - TrackerCreationDelegate

extension TrackersViewController: TrackerCreationDelegate {
    func trackerCreationDidCreate(
        _ tracker: Tracker,
        inCategory categoryTitle: String
    ) {
        dismiss(animated: true) { [weak self] in
            self?.presenter?
                .addTracker(tracker, toCategoryTitled: categoryTitle)
        }
    }

    func trackerCreationDidUpdate(
        _ tracker: Tracker,
        inCategory categoryTitle: String
    ) {
        dismiss(animated: true) { [weak self] in
            self?.presenter?.updateTracker(tracker, inCategory: categoryTitle)
        }
    }

    func trackerCreationDidCancel() {
        dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didChangeSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        presenter?.didChangeSearchText("")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfTrackers(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter = presenter,
              let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath
              ) as? TrackerCell
        else {
            return UICollectionViewCell()
        }
        let tracker = presenter.tracker(at: indexPath)
        let isCompleted = presenter.isTrackerCompleted(at: indexPath)
        let completedCount = presenter.completedCount(for: tracker.id)
        let isButtonEnabled = presenter.isActionButtonEnabled()

        cell.configure(
            with: tracker,
            isCompleted: isCompleted,
            completedCount: completedCount,
            isButtonEnabled: isButtonEnabled
        )
        cell.delegate = self
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TrackerCategoryHeaderView.reuseIdentifier,
                for: indexPath
              ) as? TrackerCategoryHeaderView
        else {
            return UICollectionReusableView()
        }
        let title = presenter?.categoryTitle(
            forSection: indexPath.section
        ) ?? ""
        header.configure(with: title)
        return header
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let editAction = UIAction(
            title: NSLocalizedString(
                "edit_action_title",
                comment: "Редактировать"
            )
        ) { [weak self] _ in
            MainScreenAnalytics.tapEdit()
            self?.presenter?.editTracker(at: indexPath)
        }
        let deleteAction = UIAction(
            title: NSLocalizedString("delete_action_title", comment: "Удалить"),
            attributes: .destructive
        ) { [weak self] _ in
            MainScreenAnalytics.tapDelete()
            self?.presenter?.deleteTracker(at: indexPath)
        }
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil
        ) { _ in
            UIMenu(title: "", children: [editAction, deleteAction])
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let spacing: CGFloat = 8
        let insets: CGFloat = 16
        let totalSpacing = spacing + insets * 2
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 148)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 46)
    }
}
