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
    
    func getPosts(page: Int?, numberOfPosts: Int?, save: Bool, completion: @escaping (_ pages: Int?, _ posts: Int?, _ error: String?) -> Void) {
        getPostsJSON(page: page, numberOfPosts: numberOfPosts) { (data, pages, posts, error) in
            
            guard error == nil else {
                completion(nil, nil, error)
                return
            }
            
            if let posts = posts, let pages = pages {
                completion(pages, posts, nil)
            }
            
            if save {
                if let data = data {
                    self.saveInCoreDataWith(dictionary: data)
                }
            }
        }
    }
    
    func createPostEntityFrom(json: [String : AnyObject]) -> NSManagedObject? {
        
        var post: Post?
        
        if let postEntity = NSEntityDescription.insertNewObject(forEntityName: "Post", into: coreDataStack.context) as? Post {
            
            let postObject = PostObject(json: json)
            postEntity.id = postObject?.id ?? 1
            postEntity.title = postObject?.title
            postEntity.link = postObject?.link
            postEntity.excerpt = postObject?.excerpt
            postEntity.featuredImageURL = postObject?.imageURL
            postEntity.cellType = postObject?.cellType
            
            DispatchQueue.main.async {
                postEntity.date = postObject?.date.toDateString(inputFormat: "yyyy-MM-dd'T'HH:mm:ss", outputFormat: "EEEE, dd MMMM")
            }

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
            post = postEntity
            
        } else {
            return nil
        }
        
        if let authorEntity = NSEntityDescription.insertNewObject(forEntityName: "Author", into: coreDataStack.context) as? Author {
            
            let authorObject = AuthorObject(json: json)
            authorEntity.id = authorObject?.id ?? 0
            authorEntity.firstName = authorObject?.firstName
            authorEntity.lastName = authorObject?.lastName
            authorEntity.nickName = authorObject?.nickName
            authorEntity.displayName = authorObject?.displayName
            authorEntity.emailAddress = authorObject?.emailAddress
            authorEntity.summary = authorObject?.summary
            authorEntity.avatarURL = authorObject?.avatarURL

            guard let imageURL = authorObject?.avatarURL, let url = getURLFromString(url: imageURL) else {
                return nil
            }
            
            imageDataFrom(String(describing: url)) { (imageData, error) in
                if error == nil {
                    DispatchQueue.main.async {
                        authorEntity.avatarImageData = imageData
                    }
                } else {
                    print(error ?? "Could not download the featured image.")
                }
            }
            
            if let post = post {
                post.author = authorEntity
                return post
            } else {
                return nil
            }
        } else {
            return nil
        }
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
