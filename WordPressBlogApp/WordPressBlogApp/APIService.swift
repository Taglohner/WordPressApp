//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Steven Taglohner on 13/08/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import Foundation

class RequestFlickrData {
    
    let session = URLSession.shared
    
    func getDataWith(completion: @escaping (Result<[String]>) -> Void) {
        
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
                return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let photos = json["photos"] as? [String] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show."))
                    }
                    completion(.Success(photos))
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
            }.resume()
    }
    
    
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
    
    
    class func sharedInstance() -> RequestFlickrData {
        struct Singleton {
            static var sharedInstance = RequestFlickrData()
        }
        return Singleton.sharedInstance
    }
}



