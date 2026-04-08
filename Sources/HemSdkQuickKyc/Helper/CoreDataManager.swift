//
//  File.swift
//  t5
//
//  Created by manas dutta on 12/12/25.
//

import Foundation
import CoreData

public final class CoreDataManager {

    @MainActor public static let shared = CoreDataManager()

    public let persistentContainer: NSPersistentContainer

    public var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private init() {
        persistentContainer = NSPersistentContainer(name: "HemSdkQuickKyc")
        persistentContainer.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Core Data load error: \(error), \(error.userInfo)")
            }
        }
    }

    public func saveContext() {
        if managedContext.hasChanges {
            do { try managedContext.save() }
            catch { print("Core Data Save Error: \(error)") }
        }
    }
}
