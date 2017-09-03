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
    var pageURL = String()
    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .orange
        actionButton.tintColor = .orange
    }
    
    func webRequest() {
        let requestURL = URL(string: pageURL)
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
        
    }
    
    
    
    
    
    
    
}
 
