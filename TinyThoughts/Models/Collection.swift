import Foundation
import CoreData

@objc(Collection)
public class Collection: NSManagedObject {
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date?
    @NSManaged public var name: String
    @NSManaged public var summary: String?
    @NSManaged public var threads: Set<Thread>?
}

// MARK: - Generated accessors for threads
extension Collection {
    @objc(addThreadsObject:)
    @NSManaged public func addToThreads(_ value: Thread)

    @objc(removeThreadsObject:)
    @NSManaged public func removeFromThreads(_ value: Thread)

    @objc(addThreads:)
    @NSManaged public func addToThreads(_ values: Set<Thread>)

    @objc(removeThreads:)
    @NSManaged public func removeFromThreads(_ values: Set<Thread>)
} 