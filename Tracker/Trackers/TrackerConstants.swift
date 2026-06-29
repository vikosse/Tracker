//
//  TrackerConstants.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 20/05/2026.
//

import UIKit

enum TrackerConstants {
    
    static var trackerCreationTitle: String { NSLocalizedString("tracker_creation_title", comment: "Заголовок экрана выбора типа трекера") }
    static var habitButtonTitle: String { NSLocalizedString("habit_button_title", comment: "Кнопка 'Привычка'") }
    static var irregularEventButtonTitle: String { NSLocalizedString("irregular_event_button_title", comment: "Кнопка 'Нерегулярное событие'") }

    static var newHabitTitle: String { NSLocalizedString("new_habit_title", comment: "Заголовок экрана создания привычки") }
    static var categoryTitle: String { NSLocalizedString("category_title", comment: "Строка 'Категория'") }
    static var scheduleTitle: String { NSLocalizedString("schedule_title", comment: "Строка 'Расписание'") }
    static var newHabitPlaceholderText: String { NSLocalizedString("new_habit_placeholder", comment: "Placeholder поля имени трекера") }
    static var defaultCategoryTitle: String { NSLocalizedString("default_category_title", comment: "Название категории по умолчанию") }

    static var newIrregularEventTitle: String { NSLocalizedString("new_irregular_event_title", comment: "Заголовок экрана создания нерегулярного события") }

    static var cancelButtonTitle: String { NSLocalizedString("cancel_button_title", comment: "Кнопка 'Отменить'") }
    static var createButtonTitle: String { NSLocalizedString("create_button_title", comment: "Кнопка 'Создать'") }
    static var doneButtonTitle: String { NSLocalizedString("done_button_title", comment: "Кнопка 'Готово'") }

    static var trackersTitle: String { NSLocalizedString("trackers_title", comment: "Заголовок вкладки трекеров") }
    static var searchPlaceholderText: String { NSLocalizedString("search_placeholder", comment: "Placeholder поля поиска") }
    static var emptyTrackerScreenTitle: String { NSLocalizedString("empty_trackers_title", comment: "Текст пустого экрана трекеров") }
    
    static let trackerNameMaxLength = 38

    // MARK: - Localization

    private static let supportedLanguages: Set<String> = ["ru", "en"]

    // Если локаль не перведена - возращаем англ как дефолтный
    static var supportedLocale: Locale {
        let code = Locale.current.language.languageCode?.identifier ?? ""
        return supportedLanguages.contains(code) ? .current : Locale(identifier: "en")
    }
    
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
