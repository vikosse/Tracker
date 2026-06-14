//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStore(_ store: TrackerCategoryStore, didUpdate update: StoreUpdate)
}

final class TrackerCategoryStore: BaseStore<TrackerCategoryCoreData> {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    init() {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: true)
        ]
        super.init(
            fetchRequest: request,
            sectionNameKeyPath: nil
        )
    }
    
    override func storeDidChange(_ update: StoreUpdate) {
        delegate?.trackerCategoryStore(self, didUpdate: update)
    }
    
    var categories: [TrackerCategoryCoreData] {
        fetchedResultsController.fetchedObjects ?? []
    }

    func findOrCreate(titled title: String) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        if let existing = try context.fetch(request).first {
            return existing
        }
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        category.createdAt = Date()
        try context.save()
        return category
    }

    func hasTrackers(at index: Int) -> Bool {
        guard index < categories.count else { return false }
        return (categories[index].trackers?.count ?? 0) > 0
    }

    func rename(at index: Int, to newTitle: String) throws {
        guard index < categories.count else { return }
        categories[index].title = newTitle
        try context.save()
    }

    func delete(at index: Int) throws {
        guard index < categories.count else { return }
        context.delete(categories[index])
        try context.save()
    }
}
