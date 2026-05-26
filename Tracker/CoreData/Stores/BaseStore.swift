//
//  BaseStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData
import UIKit

class BaseStore<Entity: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    
    let context: NSManagedObjectContext
    let fetchedResultsController: NSFetchedResultsController<Entity>
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var movedIndexes: Set<StoreUpdate.Move> = []
    private var insertedSections: IndexSet = []
    private var deletedSections: IndexSet = []
    
    init(
        context: NSManagedObjectContext,
        fetchRequest: NSFetchRequest<Entity>,
        sectionNameKeyPath: String?
    ) {
        self.context = context
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: sectionNameKeyPath,
            cacheName: nil
        )
        super.init()
        self.fetchedResultsController.delegate = self
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("BaseStore.performFetch failed: \(error)")
        }
    }
    
    func storeDidChange(_ update: StoreUpdate) {}
    
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
        storeDidChange(update)
    }
}
