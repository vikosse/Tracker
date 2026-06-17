//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 12/06/2026.
//

import UIKit

final class NewCategoryViewController: UIViewController {

    // MARK: - Constants

    private enum Layout {
        static let maxLength = TrackerConstants.trackerNameMaxLength
    }

    // MARK: - Properties

    var onComplete: ((String) -> Void)?

    private let existingTitle: String?

    // MARK: - UI

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = existingTitle == nil
            ? NSLocalizedString("new_category_title", comment: "Заголовок экрана новой категории")
            : NSLocalizedString("edit_category_title", comment: "Заголовок экрана редактирования категории")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var textFieldContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = NSLocalizedString("category_name_placeholder", comment: "Placeholder поля названия категории")
        field.font = .systemFont(ofSize: 17)
        field.clearButtonMode = .whileEditing
        field.returnKeyType = .done
        field.text = existingTitle
        field.delegate = self
        field
            .addTarget(
                self,
                action: #selector(textChanged),
                for: .editingChanged
            )
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var doneButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle(TrackerConstants.doneButtonTitle, for: .normal)
        btn.setTitleColor(.ypWhite, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 16
        btn.isEnabled = false
        btn.backgroundColor = .ypGray
        btn.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    // MARK: - Init

    init(existingTitle: String? = nil) {
        self.existingTitle = existingTitle
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
        updateDoneButton()

        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    // MARK: - Private

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(textFieldContainer)
        textFieldContainer.addSubview(nameTextField)
        view.addSubview(doneButton)
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

                textFieldContainer.topAnchor
                    .constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
                textFieldContainer.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 16),
                textFieldContainer.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -16),
                textFieldContainer.heightAnchor.constraint(equalToConstant: 75),

                nameTextField.leadingAnchor
                    .constraint(
                        equalTo: textFieldContainer.leadingAnchor,
                        constant: 16
                    ),
                nameTextField.trailingAnchor
                    .constraint(
                        equalTo: textFieldContainer.trailingAnchor,
                        constant: -16
                    ),
                nameTextField.centerYAnchor
                    .constraint(equalTo: textFieldContainer.centerYAnchor),

                doneButton.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 20),
                doneButton.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -20),
                doneButton.bottomAnchor
                    .constraint(
                        equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                        constant: -16
                    ),
                doneButton.heightAnchor.constraint(equalToConstant: 60),
            ]
        )
    }

    private func updateDoneButton() {
        let hasText = !(nameTextField.text ?? "").trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty
        doneButton.isEnabled = hasText
        doneButton.backgroundColor = hasText ? .ypBlack : .ypGray
    }

    // MARK: - Actions

    @objc private func textChanged() {
        updateDoneButton()
    }

    @objc private func doneTapped() {
        guard let title = nameTextField.text?.trimmingCharacters(
            in: .whitespacesAndNewlines
        ),
              !title.isEmpty else { return }
        onComplete?(title)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate

extension NewCategoryViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let current = textField.text ?? ""
        guard let range = Range(range, in: current) else { return true }
        let newText = current.replacingCharacters(in: range, with: string)
        return newText.count <= Layout.maxLength
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
