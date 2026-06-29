//
//  TrackerFilter.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 17/06/2026.
//

import Foundation

enum TrackerFilter: Int, CaseIterable {
    case all
    case today
    case completed
    case incomplete

    var title: String {
        switch self {
        case .all:       return NSLocalizedString(
            "filter_all",
            comment: "Все трекеры"
        )
        case .today:     return NSLocalizedString(
            "filter_today",
            comment: "Трекеры на сегодня"
        )
        case .completed: return NSLocalizedString(
            "filter_completed",
            comment: "Завершённые"
        )
        case .incomplete: return NSLocalizedString(
            "filter_incomplete",
            comment: "Не завершённые"
        )
        }
    }
}
