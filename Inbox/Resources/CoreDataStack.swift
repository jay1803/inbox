//
//  CoreDataStack.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/7/17.
//

import CoreData

class CoreDataStack: NSObject {
    // MARK: - Properties
    let context: NSManagedObjectContext
    let coordinator: NSPersistentStoreCoordinator
    let model: NSManagedObjectModel
    let store: NSPersistentStore?
    
    
    // MARK: - Singleton
    static func defaultStack() -> CoreDataStack {
        return instance
    }
    
    private static let instance = CoreDataStack()
    
    private override init() {
        // 构建托管对象模型
        let bundle = Bundle.main
        let modelURL = bundle.url(forResource: "entry", withExtension: "momd")!
        model = NSManagedObjectModel(contentsOf: modelURL)!
        
        // 构建持久化助理
        coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        // 构建托管对象上下文
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        
        // 构建持久化存储
        let manager = FileManager.default
        let urls = manager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentURL = urls.first!
        let storeURL = documentURL.appendingPathComponent("entry")
        store = (try! coordinator.addPersistentStore(type: .sqlite, at: storeURL))
    }
    
    // MARK: - Function
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("failed to save...")
            }
        }
    }
}
