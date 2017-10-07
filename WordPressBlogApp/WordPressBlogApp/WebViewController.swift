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

    @IBOutlet weak var shareButton: UIBarButtonItem!
    var webView: WKWebView!
    var postID = Int()
    let lightGrayColor = UIColor(r: 236, g: 236, b: 236, alpha: 1)
    let activityIndicatorView = NVActivityIndicatorView(frame: UIScreen.main.bounds, type: .ballPulse, color: .orange, padding: 190)
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* setup the activityIndicatorView */
        activityIndicatorView.backgroundColor = lightGrayColor
        self.webView.addSubview(activityIndicatorView)
        
        /* configure UI */
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.delegate = self
        webView.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicatorView.startAnimating()
        shareButton.isEnabled = false
        
        /* Observe content loading progress */
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        /* make the web request */
        webRequest()
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if webView.estimatedProgress == 1.0 {
                activityIndicatorView.stopAnimating()
                shareButton.isEnabled = true
            }
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
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


