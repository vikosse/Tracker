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
