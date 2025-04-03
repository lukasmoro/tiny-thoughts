//
//  Persistence.swift
//  TinyThoughts
//
//  Created by Lukas Moro on 02.04.25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample collections
        let collections = [
            ("Daily Reflections", "My everyday thoughts and observations"),
            ("Project Ideas", "Brainstorming and ideas for future projects"),
            ("Reading Notes", "Notes and thoughts from books I'm reading")
        ]
        
        var createdCollections: [Collection] = []
        
        for (name, summary) in collections {
            let collection = Collection(context: viewContext)
            collection.id = UUID()
            collection.name = name
            collection.summary = summary
            collection.creationDate = Date().addingTimeInterval(-Double.random(in: 0...86400*30))
            collection.lastModified = collection.creationDate
            createdCollections.append(collection)
        }
        
        // Create sample threads for each collection
        let threads = [
            ("Morning Reflections", "Thoughts captured during morning routine"),
            ("Evening Wind-down", "End of day reflections and thoughts"),
            ("Random Observations", "Miscellaneous observations throughout the day")
        ]
        
        for collection in createdCollections {
            for (title, summary) in threads {
                let thread = Thread(context: viewContext)
                thread.id = UUID()
                thread.title = title
                thread.summary = summary
                thread.creationDate = Date().addingTimeInterval(-Double.random(in: 0...86400*15))
                thread.lastModified = thread.creationDate
                thread.collection = collection
                
                // Add 2-4 thoughts to each thread
                let thoughtCount = Int.random(in: 2...4)
                for i in 0..<thoughtCount {
                    let thought = Thought(context: viewContext)
                    thought.id = UUID()
                    thought.content = "Sample thought #\(i+1) in \(thread.title ?? "Untitled"). This is a sample thought for preview purposes."
                    thought.creationDate = Date().addingTimeInterval(-Double.random(in: 0...86400*10))
                    thought.lastModified = thought.creationDate
                    thought.position = Int16(i)
                    thought.thread = thread
                }
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TinyThoughts")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
