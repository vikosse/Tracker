//
//  TrackerConstants.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 20/05/2026.
//

import UIKit

enum TrackerConstants {
    
    static let TrackerCreationTitle = "Создание трекера"
    static let habitButtonTitle = "Привычка"
    static let irregularEventButtonTitle = "Нерегулярное событие"
    
    static let newHabitTitle = "Новая привычка"
    static let categoryTitle = "Категория"
    static let scheduleTitle = "Расписание"
    static let newHabitPlaceholderText = "Введите название трекера"
    static let defaultCategoryTitle = "Важное"
    
    static let newIrregularEventTitle = "Новое нерегулярное событие"
    
    static let cancelButtonTitle = "Отменить"
    static let createButtonTitle = "Создать"
    static let doneButtonTitle = "Готово"
    
    static let trackersTitle = "Трекеры"
    static let searchPlaceholderText = "Поиск"
    static let emptyTrackerScreenTitle = "Что будем отслеживать?"
    
    static let trackerNameMaxLength = 38
    
    static let availableEmojis: [String] = [
        "🙂", "⏰", "✨", "⚽️", "❤️", "☺️",
        "😇", "😎", "🥹", "🤔", "🙌", "🍔",
        "🥨", "🍏", "🥇", "🙈", "☎️", "🗿"
    ]
    
    static let availableColors: [UIColor] = (1...18).compactMap { index in
        let name = String(format: "ColorSelection%02d", index)
        return UIColor(named: name)
    }
    
    static func randomEmoji() -> String {
        availableEmojis.randomElement() ?? "🙂"
    }
    
    static func randomColor() -> UIColor {
        availableColors.randomElement() ?? .systemBlue
    }
}
