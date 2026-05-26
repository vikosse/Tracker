//
//  TrackerRecordStore.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 25/05/2026.
//

import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStore(_ store: TrackerRecordStore, didUpdate update: StoreUpdate)
}

final class TrackerRecordStore: BaseStore<TrackerRecordCoreData> {
    
    weak var delegate: TrackerRecordStoreDelegate?
    
    init(context: NSManagedObjectContext) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        super.init(
            context: context,
            fetchRequest: request,
            sectionNameKeyPath: nil
        )
    }
    
    override func storeDidChange(_ update: StoreUpdate) {
        delegate?.trackerRecordStore(self, didUpdate: update)
    }
    
    func addRecord(trackerId: UUID, date: Date) {
        guard let trackerCoreData = fetchTrackerCoreData(by: trackerId) else { return }
        let record = TrackerRecordCoreData(context: context)
        record.id = UUID()
        record.date = date
        record.tracker = trackerCoreData
        do {
            try context.save()
        } catch {
            print("TrackerRecordStore.addRecord failed: \(error)")
        }
    }
    
    func removeRecord(trackerId: UUID, on date: Date) {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = sameDayPredicate(trackerId: trackerId, date: date)
        do {
            let records = try context.fetch(request)
            records.forEach { context.delete($0) }
            try context.save()
        } catch {
            print("TrackerRecordStore.removeRecord failed: \(error)")
        }
    }
    
    func isCompleted(trackerId: UUID, on date: Date) -> Bool {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = sameDayPredicate(trackerId: trackerId, date: date)
        request.fetchLimit = 1
        do {
            return try context.count(for: request) > 0
        } catch {
            print("TrackerRecordStore.isCompleted failed: \(error)")
            return false
        }
    }
    
    func recordsCount(for trackerId: UUID) -> Int {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        request.predicate = NSPredicate(format: "tracker.id == %@", trackerId as CVarArg)
        do {
            return try context.count(for: request)
        } catch {
            print("TrackerRecordStore.recordsCount failed: \(error)")
            return 0
        }
    }
    
    func fetchAllRecords() -> [TrackerRecord] {
        let objects = fetchedResultsController.fetchedObjects ?? []
        return objects.compactMap { record(from: $0) }
    }
    
    private func record(from coreData: TrackerRecordCoreData) -> TrackerRecord? {
        guard
            let trackerId = coreData.tracker?.id,
            let date = coreData.date
        else { return nil }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
    
    private func fetchTrackerCoreData(by id: UUID) -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            print("TrackerRecordStore.fetchTrackerCoreData failed: \(error)")
            return nil
        }
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
