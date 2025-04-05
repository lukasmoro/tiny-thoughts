//
//  Persistence.swift
//  TinyThoughts
//
//  created for tiny software by lukas moro
//
//  persistence controller is a singleton that manages the core data stack
//  handles the creation of the persistent container
//  provides a shared controller for the app
//  provides a preview controller for prototyping

import CoreData

struct PersistenceController {
    
    // MARK: - Properties
    // shared instance of the persistence controller
    static let shared = PersistenceController()

    // MARK: - Container
    // container is the persistent container that manages the core data stack   
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "TinyThoughts")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // add errorhandling here
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Preview
    // preview instance of the persistence controller (NOT NEEDED IN PRODUCTION)
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        //sample collections
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
        
        //sample threads for each collection
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
                
                //2-4 thoughts to each thread
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
}
