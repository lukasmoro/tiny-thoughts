//
//  CollectionViewModel.swift
//  TinyThoughts
//
//  Created for MVVM refactoring
//

import Foundation
import CoreData
import Combine

class CollectionViewModel: ObservableObject {
    @Published var collections: [Collection] = []
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchCollections()
    }
    
    func fetchCollections() {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Collection.lastModified, ascending: false)]
        
        do {
            collections = try viewContext.fetch(request)
        } catch {
            print("Error fetching collections: \(error)")
        }
    }
    
    func addCollection(name: String, summary: String? = nil) {
        let newCollection = Collection(context: viewContext)
        newCollection.id = UUID()
        newCollection.name = name
        newCollection.summary = summary
        newCollection.creationDate = Date()
        newCollection.lastModified = Date()
        
        saveContext()
    }
    
    func updateCollection(_ collection: Collection, name: String, summary: String? = nil) {
        collection.name = name
        collection.summary = summary
        collection.lastModified = Date()
        
        saveContext()
    }
    
    func deleteCollection(_ collection: Collection) {
        viewContext.delete(collection)
        saveContext()
    }
    
    func deleteCollections(at offsets: IndexSet) {
        offsets.map { collections[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchCollections()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchCollections()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return viewContext
    }
} 