//
//  HabitCreationPresenter.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 14/05/2026.
//

import Foundation

final class HabitCreationPresenter: BaseTrackerCreationPresenter {

    // MARK: - Properties

    private var schedule: Set<Weekday> = []

    private var habitView: HabitCreationViewProtocol? {
        view as? HabitCreationViewProtocol
    }

    private enum OptionRow: Int, CaseIterable {
        case category, schedule
    }

    // MARK: - Init

    override init(
        editingTracker: Tracker? = nil,
        categoryTitle: String? = nil
    ) {
        super.init(editingTracker: editingTracker, categoryTitle: categoryTitle)
        if let tracker = editingTracker {
            self.schedule = tracker.schedule
        }
    }

    // MARK: - Overrides

    override var isCreateAllowed: Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty && !schedule.isEmpty
    }
    
    override func makeTracker() -> Tracker {
        Tracker(
            id: editingTracker?.id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            color: chosenColor(),
            emoji: chosenEmoji(),
            schedule: schedule
        )
    }
    
    override func numberOfOptionRows() -> Int { OptionRow.allCases.count }
    
    override func titleForOptionRow(at index: Int) -> String {
        guard let row = OptionRow(rawValue: index) else { return "" }
        switch row {
        case .category: return TrackerConstants.categoryTitle
        case .schedule: return TrackerConstants.scheduleTitle
        }
    }
    
    override func subtitleForOptionRow(at index: Int) -> String? {
        guard let row = OptionRow(rawValue: index) else { return nil }
        switch row {
        case .category: return categoryTitle
        case .schedule: return formattedSchedule()
        }
    }
    
    // MARK: - Habit-Specific Actions
    
    func didTapScheduleRow() {
        habitView?.presentScheduleScreen(initialSchedule: schedule)
    }
    
    func didConfirmSchedule(_ days: Set<Weekday>) {
        schedule = days
        view?.reloadOptions()
        view?.setCreateButtonEnabled(isCreateAllowed)
    }
    
    // MARK: - Helpers
    
    private func formattedSchedule() -> String? {
        if schedule.isEmpty { return nil }
        if schedule.count == Weekday.allCases.count {
            return NSLocalizedString(
                "every_day",
                comment: "Расписание 'Каждый день'"
            )
        }
        let selectedDays: [Weekday] = Weekday.allCases.filter {
            schedule.contains($0)
        }
        let shortNames: [String] = selectedDays.map { $0.shortName }
        return shortNames.joined(separator: ", ")
    }
}
