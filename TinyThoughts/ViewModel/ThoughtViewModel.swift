//
//  ThoughtViewModel.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  thought view model manages thoughts
//  handles CRUD operations
//  maintains a list of thoughts
//  provides methods to add, update, and delete thoughts
//  provides a method to fetch thoughts from the database
//  provides a method to save the context

import Foundation
import CoreData
import Combine

class ThoughtViewModel: ObservableObject {
   
    // MARK: - Properties
    // published thoughts
    @Published var thoughts: [Thought] = []

    // private view context, private thread
    private var viewContext: NSManagedObjectContext
    private var thread: Thread?
    
    // MARK: - Initialization
    // initializes the thought view model for prototyping
    init(viewContext: NSManagedObjectContext, thread: Thread? = nil) {
        self.viewContext = viewContext
        self.thread = thread
        fetchThoughts()
    }

    // MARK: - Set Thread
    // sets the thread for the thought view model
    func setThread(_ thread: Thread?) {
        self.thread = thread
        fetchThoughts()
    }
    
    // MARK: - Fetch Thoughts
    // fetches thoughts from the database
    func fetchThoughts() {
        let request = NSFetchRequest<Thought>(entityName: "Thought")  
        if let thread = thread {
            request.predicate = NSPredicate(format: "thread == %@", thread)
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Thought.position, ascending: true),
                                   NSSortDescriptor(keyPath: \Thought.creationDate, ascending: false)]
        do {
            thoughts = try viewContext.fetch(request)
        } catch {
            print("Error fetching thoughts: \(error)")
        }
    }
    
    // MARK: - Add Thought
    // adds a thought to the database
    func addThought(content: String, to thread: Thread? = nil) {
        let newThought = Thought(context: viewContext)
        newThought.id = UUID()
        newThought.content = content
        newThought.creationDate = Date()
        newThought.lastModified = Date()
        newThought.position = getNextPosition()
        newThought.thread = thread ?? self.thread
        saveContext()
    }

    // MARK: - Delete Thoughts
    // deletes multiple thoughts from the database
    func deleteThoughts(at offsets: IndexSet) {
        offsets.map { thoughts[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    // MARK: - Update Thought
    // updates a thought in the database
    func updateThought(_ thought: Thought, content: String) {
        thought.content = content
        thought.lastModified = Date()
        saveContext()
    }
    
    // MARK: - Update Context
    // updates the context
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchThoughts()
    }
    
    // MARK: - Get Next Position
    // gets the next position
    private func getNextPosition(for thread: Thread? = nil) -> Int16 {
        let targetThread = thread ?? self.thread
        
        if let targetThread = targetThread {
            if let thoughts = targetThread.thoughts?.allObjects as? [Thought], !thoughts.isEmpty {
                if let maxPosition = thoughts.map({ $0.position }).max() {
                    return maxPosition + 1
                }
            }
        }
        return 0
    }
    
    // MARK: - Save Context
    // saves the context
    private func saveContext() {
        do {
            try viewContext.save()
            fetchThoughts()
        } catch {
            print("Error saving context: \(error)")
        }
    }
} 