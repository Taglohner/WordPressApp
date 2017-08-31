//
//  URLConstants.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

struct WordPressURL {
    
    static let Scheme = "http"
    static let Host = "52.32.244.193"
    static let Path = "/wp-json/wp/v2/posts"
    
    struct WordPressParameterKeys {
        
        static let Page = "page"
        static let PerPage = "per_page"
    }
    
    struct WordPressParameterValues {
        
        static let Page = "1"
        static let PerPage = "1"
    }
}
