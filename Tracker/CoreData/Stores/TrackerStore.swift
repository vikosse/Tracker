//
//  TrackerStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func trackerStore(_ store: TrackerStore, didUpdate update: StoreUpdate)
}

final class TrackerStore: BaseStore<TrackerCoreData> {
    
    weak var delegate: TrackerStoreDelegate?
    
    private let categoryStore: TrackerCategoryStore
    
    init(context: NSManagedObjectContext, categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        super.init(
            context: context,
            fetchRequest: request,
            sectionNameKeyPath: "category.title"
        )
    }
    
    override func storeDidChange(_ update: StoreUpdate) {
        delegate?.trackerStore(self, didUpdate: update)
    }
    
    func addTracker(_ tracker: Tracker, toCategoryTitled categoryTitle: String) {
        guard let category = try? categoryStore.findOrCreate(titled: categoryTitle) else { return }
        let coreData = TrackerCoreData(context: context)
        coreData.id = tracker.id
        coreData.name = tracker.name
        coreData.emoji = tracker.emoji
        coreData.color = tracker.color
        coreData.schedule = Array(tracker.schedule) as NSObject
        coreData.category = category
        try? context.save()
    }
    
    func fetchAllCategories() -> [TrackerCategory] {
        guard let sections = fetchedResultsController.sections else { return [] }
        return sections.compactMap { section in
            guard let coreDataItems = section.objects as? [TrackerCoreData] else { return nil }
            let trackers = coreDataItems.compactMap { tracker(from: $0) }
            return TrackerCategory(title: section.name, trackers: trackers)
        }
    }
    
    private func tracker(from coreData: TrackerCoreData) -> Tracker? {
        guard
            let id = coreData.id,
            let name = coreData.name,
            let emoji = coreData.emoji,
            let color = coreData.color as? UIColor
        else { return nil }
        let schedule = (coreData.schedule as? [Weekday]) ?? []
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: Set(schedule)
        )
    }
}
