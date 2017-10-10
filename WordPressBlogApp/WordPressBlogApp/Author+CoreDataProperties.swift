//
//  Author+CoreDataProperties.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 10/10/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//
//

import Foundation
import CoreData


extension Author {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Author> {
        return NSFetchRequest<Author>(entityName: "Author")
    }

    @NSManaged public var id: Int32
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var nickName: String?
    @NSManaged public var displayName: String?
    @NSManaged public var emailAddress: String?
    @NSManaged public var summary: String?
    @NSManaged public var avatarURL: String?
    @NSManaged public var avatarImageData: Data?
    @NSManaged public var posts: NSSet?
    
}

// MARK: Generated accessors for posts
extension Author {

    @objc(addPostsObject:)
    @NSManaged public func addToPosts(_ value: Post)

    @objc(removePostsObject:)
    @NSManaged public func removeFromPosts(_ value: Post)

    @objc(addPosts:)
    @NSManaged public func addToPosts(_ values: NSSet)

    @objc(removePosts:)
    @NSManaged public func removeFromPosts(_ values: NSSet)

}
