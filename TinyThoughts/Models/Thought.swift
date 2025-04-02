import Foundation
import CoreData

@objc(Thought)
public class Thought: NSManagedObject {
    @NSManaged public var content: String?
    @NSManaged public var creationDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var lastModified: Date?
    @NSManaged public var position: Int16
    @NSManaged public var thoughtTagRelations: Set<ThoughtTagRelation>?
    @NSManaged public var thread: Thread?
}

// MARK: - Generated accessors for thoughtTagRelations
extension Thought {
    @objc(addThoughtTagRelationsObject:)
    @NSManaged public func addToThoughtTagRelations(_ value: ThoughtTagRelation)

    @objc(removeThoughtTagRelationsObject:)
    @NSManaged public func removeFromThoughtTagRelations(_ value: ThoughtTagRelation)

    @objc(addThoughtTagRelations:)
    @NSManaged public func addToThoughtTagRelations(_ values: Set<ThoughtTagRelation>)

    @objc(removeThoughtTagRelations:)
    @NSManaged public func removeFromThoughtTagRelations(_ values: Set<ThoughtTagRelation>)
} 