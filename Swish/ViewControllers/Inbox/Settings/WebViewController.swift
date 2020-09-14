 //
 //  WebViewController.swift
 //  Swish
 //
 //  Created by Atemnkeng Fontem on 11/24/19.
 //  Copyright © 2019 Atemnkeng Fontem. All rights reserved.
 //

 import UIKit
 import WebKit
 class WebViewController: UIViewController, WKUIDelegate {
     
     var webView: WKWebView!
     
     var url : URL?
     
     var navTitle = ""
     
     override func loadView() {
         let webConfiguration = WKWebViewConfiguration()
         webView = WKWebView(frame: .zero, configuration: webConfiguration)
         webView.uiDelegate = self
         view = webView
     }
     override func viewDidLoad() {
         super.viewDidLoad()
        
         let backButton = UIBarButtonItem()
         backButton.title = " "
         self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
         
         self.navigationItem.title = navTitle
         
         if let myURL = url{
         let myRequest = URLRequest(url: myURL)
         webView.load(myRequest)
         }
     }
    
 }

