//
//  HabitCreationViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 14/05/2026.
//

import UIKit

final class HabitCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCreationDelegate? {
        didSet { presenter.delegate = delegate }
    }
    
    private let presenter = HabitCreationPresenter()
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.newHabitTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = TrackerConstants.newHabitPlaceholderText
        field.font = .systemFont(ofSize: 17)
        field.backgroundColor = .ypBackground
        field.layer.cornerRadius = 16
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        let paddingLeft = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        field.leftView = paddingLeft
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true
        field.delegate = self
        field.addTarget(self, action: #selector(nameChanged(_:)), for: .editingChanged)
        return field
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textColor = .ypRed
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionsContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var optionsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.rowHeight = 75
        table.dataSource = self
        table.delegate = self
        table.register(OptionCell.self, forCellReuseIdentifier: OptionCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TrackerConstants.cancelButtonTitle, for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TrackerConstants.createButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(createTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, createButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        presenter.view = self
        setupLayout()
        presenter.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(errorLabel)
        view.addSubview(optionsContainer)
        optionsContainer.addSubview(optionsTable)
        view.addSubview(buttonsStack)
        
        let optionsHeight: CGFloat = 75 * 2
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            optionsContainer.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            optionsContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            optionsContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            optionsContainer.heightAnchor.constraint(equalToConstant: optionsHeight),
            
            optionsTable.topAnchor.constraint(equalTo: optionsContainer.topAnchor),
            optionsTable.leadingAnchor.constraint(equalTo: optionsContainer.leadingAnchor),
            optionsTable.trailingAnchor.constraint(equalTo: optionsContainer.trailingAnchor),
            optionsTable.bottomAnchor.constraint(equalTo: optionsContainer.bottomAnchor),
            
            buttonsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            buttonsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        presenter.didTapCancel()
    }
    
    @objc private func createTapped() {
        presenter.didTapCreate()
    }
    
    @objc private func nameChanged(_ sender: UITextField) {
        presenter.didChangeName(sender.text ?? "")
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - HabitCreationViewProtocol

extension HabitCreationViewController: HabitCreationViewProtocol {
    
    func reloadOptions() {
        optionsTable.reloadData()
    }
    
    func setCreateButtonEnabled(_ isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .ypBlack : .ypGray
    }
    
    func setNameError(_ message: String?) {
        if let message {
            errorLabel.text = message
            errorLabel.isHidden = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
        }
    }
    
    func presentScheduleScreen(initialSchedule: Set<Weekday>) {
        let scheduleVC = ScheduleViewController()
        let schedulePresenter = SchedulePresenter(initialSelection: initialSchedule)
        scheduleVC.presenter = schedulePresenter
        schedulePresenter.view = scheduleVC
        schedulePresenter.delegate = self
        scheduleVC.modalPresentationStyle = .pageSheet
        present(scheduleVC, animated: true)
    }
}

// MARK: - ScheduleViewControllerDelegate

extension HabitCreationViewController: ScheduleViewControllerDelegate {
    func scheduleDidConfirm(_ selectedDays: Set<Weekday>) {
        dismiss(animated: true) { [weak self] in
            self?.presenter.didConfirmSchedule(selectedDays)
        }
    }
}

// MARK: - UITextFieldDelegate

extension HabitCreationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if newText.count > TrackerConstants.trackerNameMaxLength {
            setNameError("Ограничение \(TrackerConstants.trackerNameMaxLength) символов")
            return false
        } else {
            setNameError(nil)
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource / Delegate

extension HabitCreationViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfOptionRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.reuseIdentifier, for: indexPath) as? OptionCell else {
            return UITableViewCell()
        }
        let title = presenter.titleForOptionRow(at: indexPath.row)
        let subtitle = presenter.subtitleForOptionRow(at: indexPath.row)
        cell.configure(title: title, subtitle: subtitle)
        let isLast = indexPath.row == presenter.numberOfOptionRows() - 1
        cell.separatorInset = isLast
        ? UIEdgeInsets(top: 0, left: tableView.bounds.width, bottom: 0, right: 0)
        : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: presenter.didTapCategoryRow()
        case 1: presenter.didTapScheduleRow()
        default: break
        }
    }
}
