//
//  CoreDataManager.swift
//  Course2FinalTask
//
//  Created by Игорь on 25.04.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    //MARK: CoreData Stack initialisation
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func getConetxt() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createObject<T: NSManagedObject> (from entity: T.Type) -> T {
        let context = getConetxt()
        let object = NSEntityDescription.insertNewObject(forEntityName: String(describing: entity), into: context) as! T
        return object
    }
    
    func delete(object: NSManagedObject) {
        let context = getConetxt()
        context.delete(object)
        save(context: context)
    }
    
    func deleteAllEntities(entityName: String) {
        let context = getConetxt()
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
        } catch let error as NSError {
            // TODO: handle the error
        }
        
    }
    
    func fetchData<T: NSManagedObject>(for entity: T.Type, keySortDecriptor: String = "createdTime", predicate: NSCompoundPredicate? = nil) -> [T] {
        let context = getConetxt()
        
        let request: NSFetchRequest<T>
        var fetchedResult = [T]()
        
        if #available(iOS 10.0, *) {
            request = entity.fetchRequest() as! NSFetchRequest<T>
        } else {
            let entityName = String(describing: entity)
            request =  NSFetchRequest(entityName: entityName)
        }
        
        let postSortDescriptor = NSSortDescriptor(key: keySortDecriptor, ascending: false, selector: #selector(NSString.localizedStandardCompare(_:)))
        
        request.predicate = predicate
        request.sortDescriptors = [postSortDescriptor]
        
        do {
            fetchedResult = try context.fetch(request)
        } catch {
            debugPrint("Could not fetch: \(error.localizedDescription)")
        }
        
        return fetchedResult
    }
}
