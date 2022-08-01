//
//  Quote+CoreDataProperties.swift
//  Inbox
//
//  Created by Max Zhang on 2022/8/1.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var text: String?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var quoted: NSManagedObject?

}

extension Quote : Identifiable {

}
