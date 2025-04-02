import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var thoughtTagRelations: Set<ThoughtTagRelation>?
}

// MARK: - Generated accessors for thoughtTagRelations
extension Tag {
    @objc(addThoughtTagRelationsObject:)
    @NSManaged public func addToThoughtTagRelations(_ value: ThoughtTagRelation)

    @objc(removeThoughtTagRelationsObject:)
    @NSManaged public func removeFromThoughtTagRelations(_ value: ThoughtTagRelation)

    @objc(addThoughtTagRelations:)
    @NSManaged public func addToThoughtTagRelations(_ values: Set<ThoughtTagRelation>)

    @objc(removeThoughtTagRelations:)
    @NSManaged public func removeFromThoughtTagRelations(_ values: Set<ThoughtTagRelation>)
} 