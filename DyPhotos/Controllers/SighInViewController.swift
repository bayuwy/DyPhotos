//
//  SighInViewController.swift
//  DyPhotos
//
//  Created by Bayu Yasaputro on 11/11/15.
//  Copyright © 2015 DyCode. All rights reserved.
//

import UIKit

class SighInViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let authorizationURL = "https://instagram.com/oauth/authorize/?client_id=\(CLIENT_ID)&redirect_uri=\(REDIRECT_URI)&response_type=token"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        if let url = URL(string: authorizationURL) {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if let urlString = request.url?.absoluteString {
            if (urlString.range(of: "\(REDIRECT_URI)#access_token=") != nil) {
                if let accessToken = urlString.components(separatedBy: "=").last {
                    
                    UserDefaults.standard.set(accessToken, forKey: kAccessTokenKey)
                    UserDefaults.standard.synchronize()
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.showMainViewController()
                    
                    return false
                }
            }
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        webView.alpha = 0.2
        activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        webView.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        
        webView.alpha = 1.0
        activityIndicatorView.stopAnimating()
    }
}
