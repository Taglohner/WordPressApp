//
//  Convenience.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 23/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation
import CoreData

extension APIService {
    
    func getPosts(page: Int?, numberOfPosts: Int?, save: Bool, completion: @escaping (_ pages: Int, _ posts: Int) -> Void) {
        getPostsJSON(page: page, numberOfPosts: numberOfPosts) { (data, pages, posts, error) in
            guard error == nil else {
                print(error ?? "Error getting posts")
                return
            }
            if let posts = posts, let pages = pages {
                completion(pages, posts)
            }
            if save {
                if let data = data {
                    self.saveInCoreDataWith(dictionary: data)
                }
            }
        }
    }
    
    func createPostEntityFrom(json: [String : AnyObject]) -> NSManagedObject? {
        if let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: coreDataStack.context) as? Post {
            
            let object = PostObject(json: json)
            
            postEntity.type = object?.type
            postEntity.id = object?.id ?? 1
            postEntity.title = object?.title
            postEntity.modified = object?.modified
            postEntity.link = object?.link
            postEntity.excerpt = object?.excerpt
            postEntity.featuredImageURL = object?.imageURL
            postEntity.authorID = object?.authorID ?? 0
            postEntity.cellType = object?.cellType
            
            /* converting date format before saving to Core Data */
            DispatchQueue.main.async {
                postEntity.date = object?.date.toDateString(inputFormat: "yyyy-MM-dd'T'HH:mm:ss", outputFormat: "EEEE, dd MMMM")
            }
            
            /* downloading the featured image */
            if let imageURL = postEntity.featuredImageURL {
                imageDataFrom(imageURL) { (imageData, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            postEntity.featuredImage = imageData
                        }
                    } else {
                        print(error ?? "Could not download the featured image.")
                    }
                }
            }
            return postEntity
        }
        return nil
    }
    
    func saveInCoreDataWith(dictionary: [[String : AnyObject]]) {
        for object in dictionary {
            let object = createPostEntityFrom(json: object)
            if object != nil {
                coreDataStack.save()
            }
        }
    }

}
