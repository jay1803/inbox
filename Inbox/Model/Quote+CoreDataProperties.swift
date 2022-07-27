//
//  Quote+CoreDataProperties.swift
//  Flash-UIKit
//
//  Created by Max Zhang on 2022/7/18.
//
//

import Foundation
import CoreData


extension Quote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Quote> {
        return NSFetchRequest<Quote>(entityName: "Quote")
    }

    @NSManaged public var content: String?
    @NSManaged public var title: String?
    @NSManaged public var url: URL?
    @NSManaged public var quoted: Entry?

}

extension Quote : Identifiable {

}
