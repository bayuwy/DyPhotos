//
//  WebViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/6/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                
                let request = URLRequest(url: url)
                webView.loadRequest(request)
            }
        }
    }
}
