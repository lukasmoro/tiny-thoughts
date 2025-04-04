//
//  CollectionViewModel.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  collection view model manages collections
//  handles CRUD operations
//  maintains a list of collections
//  provides methods to add, update, and delete collections
//  provides a method to fetch collections from the database
//  providesa method to save the context

import Foundation
import CoreData
import Combine

class CollectionViewModel: ObservableObject {
    
    // MARK: - Properties       
    // published collections 
    @Published var collections: [Collection] = []

    // private view context
    private var viewContext: NSManagedObjectContext
    
    // MARK: - Initialization
    // initializes the collection view model for prototyping
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchCollections()
    }
    
    // MARK: - Fetch Collections
    // fetches collections from the database
    func fetchCollections() {
        let request = NSFetchRequest<Collection>(entityName: "Collection")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Collection.lastModified, ascending: false)]
        do {
            collections = try viewContext.fetch(request)
        } catch {
            print("Error fetching collections: \(error)")
        }
    }
    
    // MARK: - Add Collection
    // adds a collection to the database
    func addCollection(name: String, summary: String? = nil) {
        let newCollection = Collection(context: viewContext)
        newCollection.id = UUID()
        newCollection.name = name
        newCollection.summary = summary
        newCollection.creationDate = Date()
        newCollection.lastModified = Date()
        saveContext()
    }
    
    // MARK: - Delete Collection
    // deletes a collection from the database
    func deleteCollection(_ collection: Collection) {
        viewContext.delete(collection)
        saveContext()
    }

    // MARK: - Update Collection
    // updates a collection in the database
    func updateCollection(_ collection: Collection, name: String, summary: String? = nil) {
        collection.name = name
        collection.summary = summary
        collection.lastModified = Date()
        saveContext()
    }
    
    // MARK: - Save Context
    // saves the context
    private func saveContext() {
        do {
            try viewContext.save()
            fetchCollections()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    // MARK: - Update Context
    // updates the context
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchCollections()
    }
} 