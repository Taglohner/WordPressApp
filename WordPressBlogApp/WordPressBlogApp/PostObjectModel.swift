//
//  PostObjectModel.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//


import Foundation

struct PostObject {
    
    let type: String
    let id: Int
    let title: String
    let modified: String
    let link: String
    let content: String
    let excerpt: String
    let imageURL: String
    let date: String
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension PostObject {
    
    init(json: [String:Any]) throws {
        
        guard let type = json["type"] as? String else {
            throw SerializationError.missing("type")
        }
        
        guard let id = json["id"] as? Int else {
            throw SerializationError.missing("id")
        }
        
        guard let title = json["title"] as? [String:Any] else {
            throw SerializationError.missing("title")
        }
        
        guard let renderedTitle = title["rendered"] as? String else {
            throw SerializationError.missing("rendered title")
        }
        
        guard let date = json["date"] as? String else {
            throw SerializationError.missing("date")
        }
        
        guard let modified = json["modified"] as? String else {
            throw SerializationError.missing("modified")
        }
        
        guard let link = json["link"] as? String else {
            throw SerializationError.missing("link")
        }
        
        guard let content = json["content"] as? [String:Any] else {
            throw SerializationError.missing("content")
        }
        
        guard let renderedContent = content["rendered"] as? String else {
            throw SerializationError.missing("rendered content")
        }
        
        guard let excerpt = json["excerpt"] as? [String:Any] else {
            throw SerializationError.missing("rendered")
        }
        
        guard let renderedExcerpt = excerpt["rendered"] as? String else {
            throw SerializationError.missing("rendered excerpt")
        }
        
        guard let featuredImage = json["better_featured_image"] as? [String:Any] else {
            throw SerializationError.missing("better_featured_image")
        }
        
        guard let mediaDetails = featuredImage["media_details"] as? [String:Any] else {
            throw SerializationError.missing("media_details")
        }
        
        guard let imageSizes = mediaDetails["sizes"] as? [String:Any] else {
            throw SerializationError.missing("sizes")
        }
        guard let mediumSizeImage = imageSizes["medium"] as? [String:Any] else {
            throw SerializationError.missing("medium")
        }
        
        guard let imageURL = mediumSizeImage["source_url"] as? String else {
            throw SerializationError.missing("source_url")
        }
        
        self.type = type
        self.id = id
        self.title = renderedTitle
        self.date = date
        self.modified = modified
        self.link = link
        self.content = renderedContent
        self.excerpt = renderedExcerpt
        self.imageURL = imageURL
    }
}
 
 
