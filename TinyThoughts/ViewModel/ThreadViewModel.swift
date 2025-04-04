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
   
    // MARK: - Properties
    // published threads
    @Published var threads: [Thread] = []

    // private view context, private collection
    private var viewContext: NSManagedObjectContext
    private var collection: Collection?
    
    // MARK: - Initialization
    // initializes the thread view model for prototyping
    init(viewContext: NSManagedObjectContext, collection: Collection? = nil) {
        self.viewContext = viewContext
        self.collection = collection
        fetchThreads()
    }

    // MARK: - Set Collection
    // sets the collection for the thread view model
    // used when a user selects a collection in the quick add thought interface (NEEDS FIXING)
    func setCollection(_ collection: Collection?) {
        self.collection = collection
        fetchThreads()
    }

    // MARK: - Fetch Threads
    // fetches threads from the database
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

    // MARK: - Add Thread
    // adds a thread to the database
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

    // MARK: - Delete Threads
    // deletes threads from the database
    func deleteThreads(at offsets: IndexSet) {
        offsets.map { threads[$0] }.forEach(viewContext.delete)
        saveContext()
    }

    // MARK: - Update Thread
    // updates a thread in the database
    func updateThread(_ thread: Thread, title: String, summary: String? = nil) {
        thread.title = title
        thread.summary = summary
        thread.lastModified = Date()
        saveContext()
    }

    // MARK: - Update Context
    // updates the context for the thread view model
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchThreads()
    }

    // MARK: - Save Context
    // saves the context for the thread view model
    private func saveContext() {
        do {
            try viewContext.save()
            fetchThreads()
        } catch {
            print("Error saving context: \(error)")
        }
    }
} 