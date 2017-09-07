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
    let id: Int32
    let title: String
    let modified: String
    let link: String
    let excerpt: String
    let imageURL: String
    let date: String
}

extension PostObject {
    init?(json: [String:Any]) {
        guard let type = json["type"] as? String,
            let id = json["id"] as? Int32,
            let title = json["title"] as? [String:Any],
            let renderedTitle = title["rendered"] as? String,
            let date = json["date"] as? String,
            let modified = json["modified"] as? String,
            let link = json["link"] as? String,
            let excerpt = json["excerpt"] as? [String:Any],
            let renderedExcerpt = excerpt["rendered"] as? String,
            let featuredImage = json["better_featured_image"] as? [String:Any],
            let mediaDetails = featuredImage["media_details"] as? [String:Any],
            let imageSizes = mediaDetails["sizes"] as? [String:Any],
            let mediumSizeImage = imageSizes["medium"] as? [String:Any],
            let featuredImageURL = mediumSizeImage["source_url"] as? String
            else {
                return nil
        }
        self.type = type
        self.id = id
        self.title = renderedTitle
        self.date = date
        self.modified = modified
        self.link = link
        self.excerpt = renderedExcerpt
        self.imageURL = featuredImageURL
    }
}

struct Response {
    static var numberOfPages = 0
    static var numberOfPosts = 0
}
