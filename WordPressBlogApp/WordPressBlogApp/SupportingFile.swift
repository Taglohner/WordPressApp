//
//  SupportingFile.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

extension RequestWordPressData {
    
    /* fetch posts and return an array of initialized post objects */
    
    func getPost(completion: @escaping (Result<[Post]>) -> Void) {
        
        getDataWith { (result) in
            
            switch result {
                
            case .Success(let data):
                
                var posts = [Post]()
                
                for object in data {
                    if let postObject = Post(json: object) {
                        posts.append(postObject)
                    } else {
                        print("Error converting JSON to Post object")
                    }
                }
                
                completion(.Success(posts))
                
            case .Error(let error):
                completion(.Error(error))
            }
        }
    }
    

 
}
