//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Failed to load Core Data store: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
