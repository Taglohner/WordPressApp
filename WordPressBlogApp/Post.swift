//
//  Post+CoreDataClass.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import CoreData

@objc(Post)
public class Post: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(type: String, id: Int, title: String, date: String, modified: String, link: String, content: String, excerpt: String, imageURL: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Post", in: context)
        super.init(entity: entity!, insertInto: context)
    }
    
    init(imageData: Image, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        super.init(entity: entity!, insertInto: context)
        image = imageData
    }
    
    
    
}
