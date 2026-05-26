//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import CoreData

final class CoreDataStack {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Failed to load Core Data store: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func bootstrap() {
        _ = persistentContainer
    }
    
    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            assertionFailure("Failed to save context: \(nserror), \(nserror.userInfo)")
        }
    }
    
    // MARK: - Store factories
    
    func makeTrackerCategoryStore() -> TrackerCategoryStore {
        TrackerCategoryStore(context: viewContext)
    }
    
    func makeTrackerStore(categoryStore: TrackerCategoryStore) -> TrackerStore {
        TrackerStore(context: viewContext, categoryStore: categoryStore)
    }
    
    func makeTrackerRecordStore() -> TrackerRecordStore {
        TrackerRecordStore(context: viewContext)
    }
}
