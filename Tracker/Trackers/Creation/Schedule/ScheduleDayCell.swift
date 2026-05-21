//
//  ScheduleDayCell.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/05/2026.
//

import UIKit

final class ScheduleDayCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "ScheduleDayCell"
    
    var onSwitchChanged: ((Bool) -> Void)?
    
    // MARK: - UI Elements
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var daySwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .ypBlue
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
        return toggle
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(daySwitch)
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(day: Weekday, isOn: Bool, isLast: Bool) {
        dayLabel.text = day.fullName
        daySwitch.isOn = isOn
        
        separatorInset = isLast
        ? UIEdgeInsets(top: 0, left: bounds.width, bottom: 0, right: 0)
        : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    // MARK: - Actions
    
    @objc private func switchChanged(_ sender: UISwitch) {
        onSwitchChanged?(sender.isOn)
    }
}
