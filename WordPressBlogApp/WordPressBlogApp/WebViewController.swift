//
//  WebViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 03/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var actionButton: UIBarButtonItem!
    var postID = Int()
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Configure UI */
        
        self.navigationController?.navigationBar.tintColor = .orange
        actionButton.tintColor = .orange
        
        webRequest()
    }
    
    func webRequest() {
        
        let postURL = "http://52.32.244.193/?p=\(postID)&content-only=1&css=1"
        let requestURL = URL(string: postURL)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    @IBAction func sharePost(_ sender: UIBarButtonItem) {
        let postURL = "http://52.32.244.193/?p=\(postID)"
        if let shareURL = URL(string: postURL) {
            let objectToShare = [shareURL]
            let activityViewController = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    
    
    
    
    
    
}
 
