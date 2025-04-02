import Foundation
import CoreData

@objc(Thread)
public class Thread: NSManagedObject {
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date?
    @NSManaged public var summary: String?
    @NSManaged public var title: String?
    @NSManaged public var collection: Collection?
    @NSManaged public var thoughts: Set<Thought>?
}

// MARK: - Generated accessors for thoughts
extension Thread {
    @objc(addThoughtsObject:)
    @NSManaged public func addToThoughts(_ value: Thought)

    @objc(removeThoughtsObject:)
    @NSManaged public func removeFromThoughts(_ value: Thought)

    @objc(addThoughts:)
    @NSManaged public func addToThoughts(_ values: Set<Thought>)

    @objc(removeThoughts:)
    @NSManaged public func removeFromThoughts(_ values: Set<Thought>)
} 