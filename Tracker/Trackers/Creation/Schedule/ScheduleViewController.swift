//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/05/2026.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: SchedulePresenterProtocol?
    
    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = TrackerConstants.scheduleTitle
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false
        table.rowHeight = 75
        table.dataSource = self
        table.delegate = self
        table.register(ScheduleDayCell.self, forCellReuseIdentifier: ScheduleDayCell.reuseIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TrackerConstants.doneButtonTitle, for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupLayout()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(tableContainer)
        tableContainer.addSubview(tableView)
        view.addSubview(doneButton)
        
        let tableHeight: CGFloat = 75 * 7
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableContainer.heightAnchor.constraint(equalToConstant: tableHeight),
            
            tableView.topAnchor.constraint(equalTo: tableContainer.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableContainer.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableContainer.bottomAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func doneTapped() {
        presenter?.didTapDone()
    }
}

// MARK: - ScheduleViewProtocol

extension ScheduleViewController: ScheduleViewProtocol {
    func reloadDays() {
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource / Delegate

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfDays() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter,
              let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleDayCell.reuseIdentifier, for: indexPath) as? ScheduleDayCell
        else {
            return UITableViewCell()
        }
        let day = presenter.day(at: indexPath.row)
        let isOn = presenter.isDaySelected(day)
        let isLast = indexPath.row == presenter.numberOfDays() - 1
        cell.configure(day: day, isOn: isOn, isLast: isLast)
        cell.onSwitchChanged = { [weak presenter] isOn in
            presenter?.toggleDay(day, isOn: isOn)
        }
        return cell
    }
}

