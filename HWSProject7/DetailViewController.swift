//
//  DetailViewController.swift
//  HWSProject7
//
//  Created by Michelangelo on 29/11/15.
//  Copyright (c) 2015 Michelangelo. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webView: WKWebView!
    var detailItem: [String: String]!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if detailItem != nil {
            if let body = detailItem["body"] {
                var html = "<html>"
                html += "<head>"
                html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
                html += "<style> body { font-size: 150%; } </style>"
                html += "</head>"
                html += "<body>"
                html += body
                html += "</body>"
                html += "</html>"
                webView.loadHTMLString(html, baseURL: nil)
            }
        }
    }

}

