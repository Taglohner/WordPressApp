//
//  WebViewController.swift
//  WordPressBlogApp
//
//  Created by Steven Taglohner on 03/09/2017.
//  Copyright © 2017 Steven Taglohner. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate, UIScrollViewDelegate {
    
    //MARK: Properties
    var postID = Int()
    var webView: WKWebView!

    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* configure UI */
        webView.scrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* make the request */
        webRequest()
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    //MARK: Helper methods and actions
    
    private func webRequest() {
        let postURL = "http://52.32.244.193/?p=\(postID)"
        let requestURL = URL(string: postURL)
        let request = URLRequest(url: requestURL!)
        webView.load(request)
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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


