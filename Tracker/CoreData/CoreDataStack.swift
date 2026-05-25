//
//  CoreDataStack.swift
//  Tracker
//
//  Created by Alekhina Viktoriya on 24/05/2026.
//

import CoreData

final class CoreDataStack {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TrackerDataModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("Не удалось загрузить Core Data store: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            assertionFailure("Не удалось сохранить контекст: \(nserror), \(nserror.userInfo)")
        }
    }
}
