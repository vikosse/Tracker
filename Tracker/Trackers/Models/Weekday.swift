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
        case .monday:    return NSLocalizedString("weekday_short_monday", comment: "Короткое имя: Пн")
        case .tuesday:   return NSLocalizedString("weekday_short_tuesday", comment: "Короткое имя: Вт")
        case .wednesday: return NSLocalizedString("weekday_short_wednesday", comment: "Короткое имя: Ср")
        case .thursday:  return NSLocalizedString("weekday_short_thursday", comment: "Короткое имя: Чт")
        case .friday:    return NSLocalizedString("weekday_short_friday", comment: "Короткое имя: Пт")
        case .saturday:  return NSLocalizedString("weekday_short_saturday", comment: "Короткое имя: Сб")
        case .sunday:    return NSLocalizedString("weekday_short_sunday", comment: "Короткое имя: Вс")
        }
    }

    var fullName: String {
        switch self {
        case .monday:    return NSLocalizedString("weekday_full_monday", comment: "Полное имя: Понедельник")
        case .tuesday:   return NSLocalizedString("weekday_full_tuesday", comment: "Полное имя: Вторник")
        case .wednesday: return NSLocalizedString("weekday_full_wednesday", comment: "Полное имя: Среда")
        case .thursday:  return NSLocalizedString("weekday_full_thursday", comment: "Полное имя: Четверг")
        case .friday:    return NSLocalizedString("weekday_full_friday", comment: "Полное имя: Пятница")
        case .saturday:  return NSLocalizedString("weekday_full_saturday", comment: "Полное имя: Суббота")
        case .sunday:    return NSLocalizedString("weekday_full_sunday", comment: "Полное имя: Воскресенье")
        }
    }
}
