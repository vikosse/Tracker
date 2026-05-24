//
//  Weekday.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 18/05/2026.
//

import Foundation

enum Weekday: Int, CaseIterable, Hashable, Codable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

// MARK: - Date Conversion

extension Weekday {
    init?(date: Date, calendar: Calendar = .current) {
        let weekdayNumber = calendar.component(.weekday, from: date)
        let mondayBasedIndex = (weekdayNumber + 5) % 7
        self.init(rawValue: mondayBasedIndex)
    }
}

// MARK: - Display Names

extension Weekday {
    var shortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
    
    var fullName: String {
        switch self {
        case .monday: return "Понедельник"
        case .tuesday: return "Вторник"
        case .wednesday: return "Среда"
        case .thursday: return "Четверг"
        case .friday: return "Пятница"
        case .saturday: return "Суббота"
        case .sunday: return "Воскресенье"
        }
    }
}
