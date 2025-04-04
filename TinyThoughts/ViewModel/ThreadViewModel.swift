//
//  ThreadViewModel.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thread view model manages threads
//  handles CRUD operations
//  maintains a list of threads
//  provides methods to add, update, and delete threads
//  provides a method to fetch threads from the database
//  provides a method to save the context

import Foundation
import CoreData
import Combine

class ThreadViewModel: ObservableObject {
   
    @Published var threads: [Thread] = []
    private var viewContext: NSManagedObjectContext
    private var collection: Collection?
    
    init(viewContext: NSManagedObjectContext, collection: Collection? = nil) {
        self.viewContext = viewContext
        self.collection = collection
        fetchThreads()
    }
    
    func fetchThreads() {
        let request = NSFetchRequest<Thread>(entityName: "Thread")
        
        if let collection = collection {
            request.predicate = NSPredicate(format: "collection == %@", collection)
        }
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Thread.lastModified, ascending: false)]
        
        do {
            threads = try viewContext.fetch(request)
        } catch {
            print("Error fetching threads: \(error)")
        }
    }
    
    func addThread(title: String, summary: String? = nil, in collection: Collection) {
        let newThread = Thread(context: viewContext)
        newThread.id = UUID()
        newThread.title = title
        newThread.summary = summary
        newThread.creationDate = Date()
        newThread.lastModified = Date()
        newThread.collection = collection
        
        saveContext()
    }
    
    func updateThread(_ thread: Thread, title: String, summary: String? = nil) {
        thread.title = title
        thread.summary = summary
        thread.lastModified = Date()
        
        saveContext()
    }
    
    func moveThread(_ thread: Thread, to newCollection: Collection) {
        thread.collection = newCollection
        thread.lastModified = Date()
        
        saveContext()
    }
    
    func deleteThread(_ thread: Thread) {
        viewContext.delete(thread)
        saveContext()
    }
    
    func deleteThreads(at offsets: IndexSet) {
        offsets.map { threads[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func setCollection(_ collection: Collection?) {
        self.collection = collection
        fetchThreads()
    }
    
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchThreads()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchThreads()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return viewContext
    }
} 