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
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        super.init(
            context: context,
            fetchRequest: request,
            sectionNameKeyPath: nil
        )
    }
    
    override func storeDidChange(_ update: StoreUpdate) {
        delegate?.trackerCategoryStore(self, didUpdate: update)
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
        try context.save()
        return category
    }
}
