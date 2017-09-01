//
//  Image+CoreDataClass.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import CoreData

@objc(Image)
public class Image: NSManagedObject {
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(imageData: Data, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: context)
        super.init(entity: entity!, insertInto: context)
        image = imageData
    }
}
