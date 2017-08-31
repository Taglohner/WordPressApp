//
//  PostObjectModel.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

struct Post {
    
    let type: String
    let id: Int
    let title: [String:String]
    let date: String
    let modified: String
    let link: String
    let content: String
    let excerpt: String
    let imageURL: String
}

extension Post {
    
    init?(json: [String:Any]) {
        
        guard let type = json["type"] as? String,
            let id = json["id"] as? Int,
            let title = json["title"] as? [String:String],
            let date = json["date"] as? String,
            let modified = json["modified"] as? String,
            let link = json["link"] as? String,
            let content = json["content"] as? [String:Any],
            let renderedContent = content["rendered"] as? String,
            let excerpt = json["excerpt"] as? [String:Any],
            let renderedExcerpt = excerpt["rendered"] as? String,
            let featuredImage = json["better_featured_image"] as? [String:Any],
            let mediaDetails = featuredImage["media_details"] as? [String:Any],
            let imageSizes = mediaDetails["sizes"] as? [String:Any],
            let mediumSizeImage = imageSizes["medium"] as? [String:Any],
            let imageURL = mediumSizeImage["source_url"] as? String
        else {
            return nil
        }
        
        self.type = type
        self.id = id
        self.title = title
        self.date = date
        self.modified = modified
        self.link = link
        self.content = renderedContent
        self.excerpt = renderedExcerpt
        self.imageURL = imageURL
    }
}
