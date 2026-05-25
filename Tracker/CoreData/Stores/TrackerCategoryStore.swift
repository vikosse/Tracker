//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStore(_ store: TrackerCategoryStore, didUpdate update: StoreUpdate)
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var movedIndexes: Set<StoreUpdate.Move> = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        return controller
    }()
    
    // MARK: - Init
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        try? fetchedResultsController.performFetch()
    }
    
    // MARK: - Public API
    
    func findOrCreate(titled title: String) throws -> TrackerCategoryCoreData {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        if let existing = try context.fetch(request).first {
            return existing
        }
        let category = TrackerCategoryCoreData(context: context)
        category.title = title
        return category
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = []
        updatedIndexes = []
        movedIndexes = []
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
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let update = StoreUpdate(
            insertedIndexes: IndexSet(insertedIndexes.map { $0.item }),
            deletedIndexes: IndexSet(deletedIndexes.map { $0.item }),
            updatedIndexes: IndexSet(updatedIndexes.map { $0.item }),
            movedIndexes: movedIndexes,
            insertedSections: IndexSet(),
            deletedSections: IndexSet()
        )
        delegate?.trackerCategoryStore(self, didUpdate: update)
    }
}
