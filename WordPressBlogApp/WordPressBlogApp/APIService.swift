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
    
    func getPostsResponse(page: Int?, numberOfPosts: Int?, completion: @escaping ( _ data: [[String : AnyObject]]?, _ totalPages: Int?, _ totalPosts: Int?, _ error: String?) -> Void) {
        
        let parameters = [ WordPressURL.WordPressParameterKeys.Page : page, WordPressURL.WordPressParameterKeys.PerPage : numberOfPosts ?? 10] as [String : AnyObject]
        let url = self.URLFromParameters(parameters, WordPressURL.Scheme, WordPressURL.Host, WordPressURL.Path)
        session.dataTask(with: url) { (data, response, error) in
            
            var totalPages = Int()
            var totalPosts = Int()
            
            guard error == nil else {
                return completion(nil, nil, nil, error?.localizedDescription ?? "Unknown error returned from network request")
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if let numberOfPages = httpResponse.allHeaderFields["X-WP-TotalPages"], let numberOfPosts = httpResponse.allHeaderFields["X-WP-Total"]{
                    totalPages = Int(numberOfPages as! String) ?? 0
                    totalPosts = Int(numberOfPosts as! String) ?? 0
                }
            } else {
                return completion(nil, nil, nil, "Failed getting network response")
            }
            
            guard let data = data else {
                return completion(nil, nil, nil, "Error parsing data")
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String : AnyObject]] {
                    completion(json, totalPages, totalPosts, nil)
                }
            } catch let error {
                completion(nil, nil, nil, error.localizedDescription)
            }
            }.resume()
    }
    
    /* get image data from a provided URL */
    func imageDataFrom(_ stringURL: String, completion: @escaping (Result<Data>) -> Void) {
        
        guard let url = NSURL(string: stringURL) else {
            return completion(.Error("Provided URL is invalid"))
        }
        let request = URLRequest(url: url as URL)
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



