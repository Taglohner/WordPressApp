//
//  Image+CoreDataProperties.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var post: Post?

}
