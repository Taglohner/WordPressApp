//
//  LaunchScreenViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 06/10/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController, NVActivityIndicatorViewable {
    
    //MARK: Properties
    
    let reachability = Reachability()!
    let coreDataStack = AppDelegate.stack
    let wordpressAPIService = APIService.sharedInstance()
    
    let launchScreenView = LaunchScreenView()
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 18, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 18), type: .ballPulse, color: .orange, padding: 190)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView.backgroundColor = .none
        activityIndicatorView.startAnimating()
        
        /* ActivityIndicatorView View */
        launchScreenView.frame = self.view.frame
        launchScreenView.backgroundColor = .white
        launchScreenView.addSubview(activityIndicatorView)
        self.view.addSubview(launchScreenView)
        
        perform(#selector(toMain), with: self, afterDelay: 5)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    @objc func toMain(){
        self.performSegue(withIdentifier: "toMain", sender: self)
        stopAnimating()
    }
    
    
    
    
    func fetchFreshData(){
        if reachability.connection != .none {
            
            /* clear all data */
            coreDataStack.batchDelete(context: coreDataStack.context, entityName: "Post")
            
            /* fetch new data */
            wordpressAPIService.getPosts(page: 1, numberOfPosts: nil, save: true) { (pages, posts, error) in
                guard error == nil else {
                    return print(error ?? "")
                }
                
                guard let pages = pages, let posts = posts else {
                    return print("error occurred couting posts and pages")
                }
//                lastFetchTotalPages = pages
//                lastFecthTotalPosts = posts
            }
        }
    }
    
    
    
}
