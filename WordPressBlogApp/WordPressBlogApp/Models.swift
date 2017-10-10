//
//  Models.swift
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

struct AuthorObject {
    let id: Int32
    let firstName: String
    let lastName: String
    let nickName: String
    let displayName: String
    let emailAddress: String
    let summary: String
    let avatarURL: String
}

extension AuthorObject {
    init?(json: [String:Any]) {
        guard let acf = json["acf"] as? [String:Any],
        let author = acf["author"] as? [String:Any],
        let id = author["ID"] as? Int32,
        let firstName = author["user_firstname"] as? String,
        let lastName = author["user_lastname"] as? String,
        let nickName = author["nickname"] as? String,
        let displayName = author["display_name"] as? String,
        let emailAddress = author["user_email"] as? String,
        let summary = author["user_description"] as? String,
        let avatarURL = author["user_avatar"] as? String
        
            else {
                return nil
        }
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.nickName = nickName
        self.displayName = displayName
        self.emailAddress = emailAddress
        self.summary = summary
        self.avatarURL = avatarURL
    }
}
