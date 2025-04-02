import Foundation
import CoreData

@objc(ThoughtTagRelation)
public class ThoughtTagRelation: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var tag: Tag?
    @NSManaged public var thought: Thought?
} 