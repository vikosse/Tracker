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

final class TrackerStore: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private let categoryStore: TrackerCategoryStore
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var movedIndexes: Set<StoreUpdate.Move> = []
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "category.title", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: "category.title",
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext, categoryStore: TrackerCategoryStore) {
        self.context = context
        self.categoryStore = categoryStore
        super.init()
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Public API
    
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
    
    // MARK: - Mapping
    
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

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
        insertedSections = []
        deletedSections = []
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let newIndexPath { insertedIndexes.append(newIndexPath) }
        case .delete:
            if let indexPath { deletedIndexes.append(indexPath) }
        case .update:
            if let indexPath { updatedIndexes.append(indexPath) }
        case .move:
            if let indexPath, let newIndexPath {
                movedIndexes.insert(StoreUpdate.Move(oldIndex: indexPath.item, newIndex: newIndexPath.item))
            }
        @unknown default:
            break
        }
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange sectionInfo: NSFetchedResultsSectionInfo,
        atSectionIndex sectionIndex: Int,
        for type: NSFetchedResultsChangeType
    ) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        case .delete:
            deletedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = StoreUpdate(
            insertedIndexes: IndexSet(insertedIndexes.map { $0.item }),
            deletedIndexes: IndexSet(deletedIndexes.map { $0.item }),
            updatedIndexes: IndexSet(updatedIndexes.map { $0.item }),
            movedIndexes: movedIndexes,
            insertedSections: insertedSections,
            deletedSections: deletedSections
        )
        delegate?.trackerStore(self, didUpdate: update)
    }
}
