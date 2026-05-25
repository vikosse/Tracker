//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData
import UIKit

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStore(_ store: TrackerRecordStore, didUpdate update: StoreUpdate)
}

final class TrackerRecordStore: NSObject {
    
    // MARK: - Properties
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    
    private var insertedIndexes: [IndexPath] = []
    private var deletedIndexes: [IndexPath] = []
    private var updatedIndexes: [IndexPath] = []
    private var movedIndexes: Set<StoreUpdate.Move> = []
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
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
    
    func addRecord(trackerId: UUID, date: Date) {
        guard let trackerCoreData = fetchTrackerCoreData(by: trackerId) else { return }
        let record = TrackerRecordCoreData(context: context)
        record.id = UUID()
        record.date = date
        record.tracker = trackerCoreData
        try? context.save()
    }
    
    func removeRecord(trackerId: UUID, on date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = sameDayPredicate(trackerId: trackerId, date: date)
        guard let records = try? context.fetch(request) else { return }
        records.forEach { context.delete($0) }
        try? context.save()
    }
    
    func isCompleted(trackerId: UUID, on date: Date) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = sameDayPredicate(trackerId: trackerId, date: date)
        request.fetchLimit = 1
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }
    
    func recordsCount(for trackerId: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerId as CVarArg)
        return (try? context.count(for: request)) ?? 0
    }
    
    // MARK: - Helpers
    
    private func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return (try? context.fetch(request))?.first
    }
    
    private func sameDayPredicate(trackerId: UUID, date: Date) -> NSPredicate {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        guard let end = calendar.date(byAdding: .day, value: 1, to: start) else {
            return NSPredicate(value: false)
        }
        return NSPredicate(
            format: "tracker.id == %@ AND date >= %@ AND date < %@",
            trackerId as CVarArg,
            start as NSDate,
            end as NSDate
        )
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    
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
        delegate?.trackerRecordStore(self, didUpdate: update)
    }
}
