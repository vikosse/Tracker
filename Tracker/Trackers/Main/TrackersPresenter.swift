//
//  TrackersPresenter.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 10/05/2026.
//

import UIKit

final class TrackersPresenter: TrackersPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TrackersViewProtocol?
    
    private var allCategories: [TrackerCategory] = [
        TrackerCategory(title: TrackerConstants.defaultCategoryTitle, trackers: [])
    ]
    
    private var completedTrackers: [TrackerRecord] = []
    private(set) var currentDate: Date = Date()
    private var searchText: String = ""
    private var visibleCategories: [TrackerCategory] = []
    
    // MARK: - TrackersPresenterProtocol
    
    func viewDidLoad() {
        recomputeVisibleCategories()
        updatePlaceholderAndReload()
    }
    
    func didTapAddButton() {
        view?.presentTrackerCreation()
    }
    
    func didChangeDate(_ date: Date) {
        currentDate = date
        recomputeVisibleCategories()
        updatePlaceholderAndReload()
    }
    
    func didChangeSearchText(_ text: String) {
        searchText = text
        recomputeVisibleCategories()
        updatePlaceholderAndReload()
    }
    
    func didTapTrackerAction(at indexPath: IndexPath) {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let calendar = Calendar.current
        let isAlreadyCompleted = completedTrackers.contains { record in
            record.trackerId == tracker.id
            && calendar.isDate(record.date, inSameDayAs: currentDate)
        }
        if isAlreadyCompleted {
            completedTrackers.removeAll { record in
                record.trackerId == tracker.id
                && calendar.isDate(record.date, inSameDayAs: currentDate)
            }
        } else {
            completedTrackers.append(TrackerRecord(trackerId: tracker.id, date: currentDate))
        }
        view?.reloadTrackers()
    }
    
    // MARK: - Data source
    
    func numberOfSections() -> Int {
        visibleCategories.count
    }
    
    func numberOfTrackers(in section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func tracker(at indexPath: IndexPath) -> Tracker {
        visibleCategories[indexPath.section].trackers[indexPath.item]
    }
    
    func categoryTitle(forSection section: Int) -> String {
        visibleCategories[section].title
    }
    
    func isTrackerCompleted(at indexPath: IndexPath) -> Bool {
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        return completedTrackers.contains { record in
            record.trackerId == tracker.id
            && Calendar.current.isDate(record.date, inSameDayAs: currentDate)
        }
    }
    
    func completedCount(for trackerId: UUID) -> Int {
        completedTrackers.filter { $0.trackerId == trackerId }.count
    }
    
    func isActionButtonEnabled() -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(currentDate, inSameDayAs: Date()) || currentDate < Date()
    }
    
    // MARK: - Adding new trackers
    
    func addTracker(_ tracker: Tracker, toCategoryTitled categoryTitle: String) {
        if let index = allCategories.firstIndex(where: { $0.title == categoryTitle }) {
            let category = allCategories[index]
            let updated = TrackerCategory(
                title: category.title,
                trackers: category.trackers + [tracker]
            )
            allCategories[index] = updated
        } else {
            let newCategory = TrackerCategory(title: categoryTitle, trackers: [tracker])
            allCategories.append(newCategory)
        }
        recomputeVisibleCategories()
        updatePlaceholderAndReload()
    }
    
    // MARK: - Private helpers
    
    private func recomputeVisibleCategories() {
        guard let currentWeekday = Weekday(date: currentDate) else {
            visibleCategories = []
            return
        }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        visibleCategories = allCategories.compactMap { category in
            let filtered = category.trackers.filter { tracker in
                let scheduleMatches = tracker.schedule.isEmpty || tracker.schedule.contains(currentWeekday)
                let searchMatches = query.isEmpty || tracker.name.lowercased().contains(query)
                return scheduleMatches && searchMatches
            }
            return filtered.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filtered)
        }
    }
    
    private func updatePlaceholderAndReload() {
        if visibleCategories.isEmpty {
            view?.showPlaceholder()
        } else {
            view?.hidePlaceholder()
        }
        view?.reloadTrackers()
    }
}
