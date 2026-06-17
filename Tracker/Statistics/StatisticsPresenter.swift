//
//  StatisticsPresenter.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 10/05/2026.
//

import Foundation

final class StatisticsPresenter: StatisticsPresenterProtocol {

    // MARK: - Properties

    weak var view: StatisticsViewProtocol?

    private let trackerStore: TrackerStore
    private let recordStore: TrackerRecordStore

    // MARK: - Init

    init(trackerStore: TrackerStore, recordStore: TrackerRecordStore) {
        self.trackerStore = trackerStore
        self.recordStore = recordStore
    }

    // MARK: - StatisticsPresenterProtocol

    func viewWillAppear() {
        recalculate()
    }

    // MARK: - Private

    private func recalculate() {
        let records = recordStore.fetchAllRecords()
        let categories = trackerStore.fetchAllCategories()
        let allTrackers = categories.flatMap { $0.trackers }

        let trackersCompleted = records.count
        let bestPeriod = computeBestPeriod(records: records)
        let perfectDays = computePerfectDays(
            records: records,
            trackers: allTrackers
        )
        let averageValue = computeAverageValue(records: records)

        let hasData = trackersCompleted > 0

        if hasData {
            let data = StatisticsData(
                bestPeriod: bestPeriod,
                perfectDays: perfectDays,
                trackersCompleted: trackersCompleted,
                averageValue: averageValue
            )
            view?.showStatistics(data)
        } else {
            view?.showEmptyState()
        }
    }

    private func computeBestPeriod(records: [TrackerRecord]) -> Int {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: records, by: { $0.trackerId })

        var globalMax = 0

        for (_, trackerRecords) in grouped {
            let dates = Set(trackerRecords.map {
                calendar.startOfDay(for: $0.date)
            }).sorted()

            guard !dates.isEmpty else { continue }

            var maxStreak = 1
            var currentStreak = 1

            for i in 1..<dates.count {
                let prev = dates[i - 1]
                let curr = dates[i]
                let diff = calendar.dateComponents(
                    [.day],
                    from: prev,
                    to: curr
                ).day ?? 0
                if diff == 1 {
                    currentStreak += 1
                    maxStreak = max(maxStreak, currentStreak)
                } else {
                    currentStreak = 1
                }
            }
            globalMax = max(globalMax, maxStreak)
        }
        return globalMax
    }

    private func computePerfectDays(records: [TrackerRecord], trackers: [Tracker]) -> Int {
        let calendar = Calendar.current

        let allDates = Set(records.map { calendar.startOfDay(for: $0.date) })

        var perfectCount = 0

        for date in allDates {
            guard let weekday = Weekday(date: date) else { continue }

            let scheduled = trackers.filter { tracker in
                tracker.schedule.isEmpty || tracker.schedule.contains(weekday)
            }

            guard !scheduled.isEmpty else { continue }

            let completedIds = Set(
                records
                    .filter { calendar.isDate($0.date, inSameDayAs: date) }
                    .map { $0.trackerId }
            )

            let allCompleted = scheduled.allSatisfy {
                completedIds.contains($0.id)
            }
            if allCompleted {
                perfectCount += 1
            }
        }
        return perfectCount
    }

    private func computeAverageValue(records: [TrackerRecord]) -> Int {
        guard !records.isEmpty else { return 0 }
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: records) {
            calendar.startOfDay(for: $0.date)
        }
        let totalDays = grouped.count
        guard totalDays > 0 else { return 0 }
        return records.count / totalDays
    }
}
