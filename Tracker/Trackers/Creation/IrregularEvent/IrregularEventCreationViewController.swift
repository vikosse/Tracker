//
//  IrregularEventCreationViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 19/05/2026.
//

import UIKit

final class IrregularEventCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCreationDelegate? {
        didSet { presenter.delegate = delegate }
    }
    
    private let presenter = IrregularEventCreationPresenter()
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.newIrregularEventTitle
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
        let paddingLeft = UIView(
            frame: CGRect(x: 0, y: 0, width: 16, height: 0)
        )
        field.leftView = paddingLeft
        field.leftViewMode = .always
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true
        field.delegate = self
        field
            .addTarget(
                self,
                action: #selector(nameChanged(_:)),
                for: .editingChanged
            )
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
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.rowHeight = 75
        table.dataSource = self
        table.delegate = self
        table
            .register(
                OptionCell.self,
                forCellReuseIdentifier: OptionCell.reuseIdentifier
            )
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TrackerConstants.cancelButtonTitle, for: .normal)
        button.setTitleColor(UIColor.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypWhite
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button
            .addTarget(
                self,
                action: #selector(cancelTapped),
                for: .touchUpInside
            )
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
        button
            .addTarget(
                self,
                action: #selector(createTapped),
                for: .touchUpInside
            )
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

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.alwaysBounceVertical = true
        view.keyboardDismissMode = .onDrag
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emojiColorPicker: EmojiColorPickerView = {
        let view = EmojiColorPickerView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        presenter.view = self
        setupLayout()
        presenter.viewDidLoad()
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        view.addSubview(buttonsStack)
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)

        scrollContentView.addSubview(titleLabel)
        scrollContentView.addSubview(nameTextField)
        scrollContentView.addSubview(errorLabel)
        scrollContentView.addSubview(optionsContainer)
        optionsContainer.addSubview(optionsTable)
        scrollContentView.addSubview(emojiColorPicker)

        let optionsHeight: CGFloat = 75

        NSLayoutConstraint.activate(
            [
                scrollView.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor
                    .constraint(equalTo: buttonsStack.topAnchor, constant: -16),

                scrollContentView.topAnchor
                    .constraint(
                        equalTo: scrollView.contentLayoutGuide.topAnchor
                    ),
                scrollContentView.leadingAnchor
                    .constraint(
                        equalTo: scrollView.contentLayoutGuide.leadingAnchor
                    ),
                scrollContentView.trailingAnchor
                    .constraint(
                        equalTo: scrollView.contentLayoutGuide.trailingAnchor
                    ),
                scrollContentView.bottomAnchor
                    .constraint(
                        equalTo: scrollView.contentLayoutGuide.bottomAnchor
                    ),
                scrollContentView.widthAnchor
                    .constraint(
                        equalTo: scrollView.frameLayoutGuide.widthAnchor
                    ),

                titleLabel.topAnchor
                    .constraint(
                        equalTo: scrollContentView.topAnchor,
                        constant: 27
                    ),
                titleLabel.centerXAnchor
                    .constraint(equalTo: scrollContentView.centerXAnchor),

                nameTextField.topAnchor
                    .constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                nameTextField.leadingAnchor
                    .constraint(
                        equalTo: scrollContentView.leadingAnchor,
                        constant: 16
                    ),
                nameTextField.trailingAnchor
                    .constraint(
                        equalTo: scrollContentView.trailingAnchor,
                        constant: -16
                    ),

                errorLabel.topAnchor
                    .constraint(
                        equalTo: nameTextField.bottomAnchor,
                        constant: 8
                    ),
                errorLabel.centerXAnchor
                    .constraint(equalTo: scrollContentView.centerXAnchor),

                optionsContainer.topAnchor
                    .constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
                optionsContainer.leadingAnchor
                    .constraint(
                        equalTo: scrollContentView.leadingAnchor,
                        constant: 16
                    ),
                optionsContainer.trailingAnchor
                    .constraint(
                        equalTo: scrollContentView.trailingAnchor,
                        constant: -16
                    ),
                optionsContainer.heightAnchor
                    .constraint(equalToConstant: optionsHeight),

                optionsTable.topAnchor
                    .constraint(equalTo: optionsContainer.topAnchor),
                optionsTable.leadingAnchor
                    .constraint(equalTo: optionsContainer.leadingAnchor),
                optionsTable.trailingAnchor
                    .constraint(equalTo: optionsContainer.trailingAnchor),
                optionsTable.bottomAnchor
                    .constraint(equalTo: optionsContainer.bottomAnchor),

                emojiColorPicker.topAnchor
                    .constraint(
                        equalTo: optionsContainer.bottomAnchor,
                        constant: 32
                    ),
                emojiColorPicker.leadingAnchor
                    .constraint(equalTo: scrollContentView.leadingAnchor),
                emojiColorPicker.trailingAnchor
                    .constraint(equalTo: scrollContentView.trailingAnchor),
                emojiColorPicker.bottomAnchor
                    .constraint(
                        equalTo: scrollContentView.bottomAnchor,
                        constant: -16
                    ),

                // Buttons
                buttonsStack.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 20),
                buttonsStack.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -20),
                buttonsStack.bottomAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                        constant: -16
                    ),
                buttonsStack.heightAnchor.constraint(equalToConstant: 60)
            ]
        )
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

// MARK: - IrregularEventCreationViewProtocol

extension IrregularEventCreationViewController: IrregularEventCreationViewProtocol {

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

    func presentCategoryScreen(selectedCategory: String?) {
        let viewModel = CategoryViewModel(selectedTitle: selectedCategory)
        let categoryVC = CategoryViewController(viewModel: viewModel)
        viewModel.onCategorySelected = { [weak self] title in
            self?.dismiss(animated: true) {
                self?.presenter.didConfirmCategory(title)
            }
        }
        categoryVC.modalPresentationStyle = .pageSheet
        present(categoryVC, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension IrregularEventCreationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let range = Range(range, in: currentText) else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        if newText.count > TrackerConstants.trackerNameMaxLength {
            setNameError(
                String(format: NSLocalizedString("tracker_name_limit_error", comment: "Ошибка превышения длины названия трекера"), TrackerConstants.trackerNameMaxLength)
            )
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

// MARK: - EmojiColorPickerViewDelegate

extension IrregularEventCreationViewController: EmojiColorPickerViewDelegate {

    func emojiColorPicker(
        _ view: EmojiColorPickerView,
        didSelectEmojiAt index: Int
    ) {
        presenter.didSelectEmoji(at: index)
        view.selectedEmojiIndex = presenter.selectedEmojiIndex
    }

    func emojiColorPicker(
        _ view: EmojiColorPickerView,
        didSelectColorAt index: Int
    ) {
        presenter.didSelectColor(at: index)
        view.selectedColorIndex = presenter.selectedColorIndex
    }
}

// MARK: - UITableViewDataSource / Delegate

extension IrregularEventCreationViewController: UITableViewDataSource, UITableViewDelegate {
    
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
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didTapCategoryRow()
    }
}
