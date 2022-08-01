//
//  Attachment+CoreDataProperties.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/1.
//
//

import Foundation
import CoreData


extension Attachment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Attachment> {
        return NSFetchRequest<Attachment>(entityName: "Attachment")
    }

    @NSManaged public var path: Data?
    @NSManaged public var previewImagePath: Data?
    @NSManaged public var title: String?
    @NSManaged public var type: String?
    @NSManaged public var attachedTo: Entry?

}

extension Attachment : Identifiable {

}
