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
}
