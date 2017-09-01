//
//  APIService.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 31/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

class RequestWordPressData {
    
    let session = URLSession.shared
    
    /* get JSON from WordPress */
    
    func getPostsFromWordPress(completion: @escaping (Result<[PostObject]>) -> Void) {
        
        let parameters = [
            WordPressURL.WordPressParameterKeys.Page : WordPressURL.WordPressParameterValues.Page,
            WordPressURL.WordPressParameterKeys.PerPage : WordPressURL.WordPressParameterValues.PerPage
            ] as [String : AnyObject]
        
        let url = self.URLFromParameters(parameters, WordPressURL.Scheme, WordPressURL.Host, WordPressURL.Path)
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                return completion(.Error(error!.localizedDescription))
            }
            
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? "Could not parse data."))
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String: AnyObject]] {
                    var posts = [PostObject]()
                    for object in json {
                        let postObject = try PostObject(json: object)
                        posts.append(postObject)
                    }
                    completion(.Success(posts))
                }
            } catch let error {
                completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    /* get image data from a provided URL */
    
    func imageDataFrom(_ stringURL: String, completion: @escaping (Result<Data>) -> Void) {
        
        guard let url = NSURL(string: stringURL) else {
            return completion(.Error("Provided URL is invalid"))
        }
        let request = NSURLRequest(url: url as URL)
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                return completion(.Error(error?.localizedDescription ?? "Could not get the image data."))
            }
            
            guard let data = data else {
                return completion(.Error(error?.localizedDescription ?? "Invalid image data."))
            }
            
            completion(.Success(data))
            
            }.resume()
    }
    
    enum Result <T> {
        case Success(T)
        case Error(String)
    }
    
    /* create a URL from parameters */
    
    func URLFromParameters(_ parameters: [String:AnyObject]?,_ scheme: String,_ host: String,_ path: String) -> URL {
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        return components.url!
    }
    
    /* singleton for the network tasks */
    
    class func sharedInstance() -> RequestWordPressData {
        struct Singleton {
            static var sharedInstance = RequestWordPressData()
        }
        return Singleton.sharedInstance
    }
}



