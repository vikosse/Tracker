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
        picker.locale = Locale(identifier: "ru_RU")
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
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
        imageView.image = UIImage(resource: .trackersPlaceholder)
        imageView.tintColor = .systemGray3
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.emptyTrackerScreenTitle
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImageView, placeholderLabel])
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
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupSearchBar()
        setupPlaceholder()
        setupCollectionView()
        
        presenter?.viewDidLoad()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupSearchBar() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupPlaceholder() {
        view.addSubview(placeholderStackView)
        
        NSLayoutConstraint.activate([
            placeholderStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        presenter?.didTapAddButton()
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        presenter?.didChangeDate(sender.date)
        if let presented = presentedViewController,
           presented.modalPresentationStyle == .popover {
            presented.dismiss(animated: true)
        }
    }
}

// MARK: - TrackerCellDelegate

extension TrackersViewController: TrackerCellDelegate {
    func didTapActionButton(in cell: TrackerCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        presenter?.didTapTrackerAction(at: indexPath)
    }
}

// MARK: - TrackersViewProtocol

extension TrackersViewController: TrackersViewProtocol {
    func showPlaceholder() {
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
}

// MARK: - TrackerTypeSelectionDelegate

extension TrackersViewController: TrackerTypeSelectionDelegate {
    func trackerTypeSelectionDidPickHabit(_ controller: HabitTypeSelectionViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.presentHabitCreation()
        }
    }
    
    func trackerTypeSelectionDidPickIrregularEvent(_ controller: HabitTypeSelectionViewController) {
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
    func trackerCreationDidCreate(_ tracker: Tracker, inCategory categoryTitle: String) {
        dismiss(animated: true) { [weak self] in
            self?.presenter?.addTracker(tracker, toCategoryTitled: categoryTitle)
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
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell
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
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let insets: CGFloat = 16
        let totalSpacing = spacing + insets * 2
        let width = (collectionView.bounds.width - totalSpacing) / 2
        return CGSize(width: width, height: 148)
    }
}
