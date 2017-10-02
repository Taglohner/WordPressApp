//
//  Post+CoreDataProperties.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 30/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var cellType: String?
    @NSManaged public var date: String?
    @NSManaged public var excerpt: String?
    @NSManaged public var featuredImage: Data?
    @NSManaged public var featuredImageURL: String?
    @NSManaged public var id: Int32
    @NSManaged public var link: String?
    @NSManaged public var title: String?

}
