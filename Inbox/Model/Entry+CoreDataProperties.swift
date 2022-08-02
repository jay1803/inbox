//
//  Entry+CoreDataProperties.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/2.
//
//

import Foundation
import CoreData


extension Entry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entry> {
        return NSFetchRequest<Entry>(entityName: "Entry")
    }

    @NSManaged public var content: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isArchived: Bool
    @NSManaged public var isFavorated: Bool
    @NSManaged public var updatedAt: Date?
    @NSManaged public var quote: String?
    @NSManaged public var attachments: NSSet?
    @NSManaged public var replies: NSSet?
    @NSManaged public var replyTo: Entry?

}

// MARK: Generated accessors for attachments
extension Entry {

    @objc(addAttachmentsObject:)
    @NSManaged public func addToAttachments(_ value: Attachment)

    @objc(removeAttachmentsObject:)
    @NSManaged public func removeFromAttachments(_ value: Attachment)

    @objc(addAttachments:)
    @NSManaged public func addToAttachments(_ values: NSSet)

    @objc(removeAttachments:)
    @NSManaged public func removeFromAttachments(_ values: NSSet)

}

// MARK: Generated accessors for replies
extension Entry {

    @objc(addRepliesObject:)
    @NSManaged public func addToReplies(_ value: Entry)

    @objc(removeRepliesObject:)
    @NSManaged public func removeFromReplies(_ value: Entry)

    @objc(addReplies:)
    @NSManaged public func addToReplies(_ values: NSSet)

    @objc(removeReplies:)
    @NSManaged public func removeFromReplies(_ values: NSSet)

}

extension Entry : Identifiable {

}
