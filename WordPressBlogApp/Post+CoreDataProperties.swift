//
//  Post+CoreDataProperties.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var type: String?
    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var modified: String?
    @NSManaged public var link: String?
    @NSManaged public var content: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var image: Image?

}
