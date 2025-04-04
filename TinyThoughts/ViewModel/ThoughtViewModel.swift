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
   
    @Published var thoughts: [Thought] = []
    private var cancellables = Set<AnyCancellable>()
    private var viewContext: NSManagedObjectContext
    private var thread: Thread?
    
    init(viewContext: NSManagedObjectContext, thread: Thread? = nil) {
        self.viewContext = viewContext
        self.thread = thread
        fetchThoughts()
    }
    
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
    
    func updateThought(_ thought: Thought, content: String) {
        thought.content = content
        thought.lastModified = Date()
        saveContext()
    }
    
    func moveThought(_ thought: Thought, to newThread: Thread) {
        thought.thread = newThread
        thought.lastModified = Date()
        thought.position = getNextPosition(for: newThread)
        saveContext()
    }
    
    func reorderThoughts(_ thoughts: [Thought]) {
        for (index, thought) in thoughts.enumerated() {
            thought.position = Int16(index)
        }
        saveContext()
    }
    
    func deleteThought(_ thought: Thought) {
        viewContext.delete(thought)
        saveContext()
    }
    
    func deleteThoughts(at offsets: IndexSet) {
        offsets.map { thoughts[$0] }.forEach(viewContext.delete)
        saveContext()
    }
    
    func setThread(_ thread: Thread?) {
        self.thread = thread
        fetchThoughts()
    }
    
    func updateContext(_ newContext: NSManagedObjectContext) {
        self.viewContext = newContext
        fetchThoughts()
    }
    
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
    
    private func saveContext() {
        do {
            try viewContext.save()
            fetchThoughts()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
        return viewContext
    }
} 