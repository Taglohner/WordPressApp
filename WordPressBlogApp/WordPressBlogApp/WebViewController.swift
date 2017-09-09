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

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
//        let statusBar = statWindow.subviews[0] as UIView
        
        /* configure UI */
        self.navigationController?.navigationBar.tintColor = .orange
  
        actionButton.tintColor = .orange

        /* make the request */
        webRequest()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* configure UI */
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    //MARK: Helper methods and actions
    
    private func webRequest() {
        let postURL = "http://52.32.244.193/?p=\(postID)&content-only=1&css=1"
        let requestURL = URL(string: postURL)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
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
 
