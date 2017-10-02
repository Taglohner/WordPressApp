//
//  PostObjectModel.swift
//  WordPressBlogApp
//
//  Created by Steven Admin on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

struct PostObject {
    let id: Int32
    let title: String
    let link: String
    let excerpt: String
    let imageURL: String
    let date: String
    let cellType: String
}

extension PostObject {
    init?(json: [String:Any]) {
        guard let id = json["id"] as? Int32,
            let title = json["title"] as? [String:Any],
            let renderedTitle = title["rendered"] as? String,
            let date = json["date"] as? String,
            let link = json["link"] as? String,
            let acf = json["acf"] as? [String:Any],
            let cellType = acf["cell_type"] as? String,
            let excerpt = acf["excerpt"] as? String,
            let imageURL = acf["image"] as? String
            
            else {
                return nil
        }
        self.id = id
        self.title = renderedTitle
        self.date = date
        self.link = link
        self.excerpt = excerpt
        self.imageURL = imageURL
        self.cellType = cellType
    }
}


