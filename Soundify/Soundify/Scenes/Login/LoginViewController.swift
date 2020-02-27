//
//  ViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/24/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController{
    let webView = LoginWebView()
    
    @IBOutlet weak var label: UILabel!
    
    private func spotifyAuthVC() {
        let spotifyViewController = UIViewController()
        spotifyViewController.view.addSubview(webView)
        
        webView.navigationDelegate = self
        webView.setupUI(on: spotifyViewController)
        SpotifyService.shared.login(on: webView)
        
        let loginWebView = LoginWebViewNavigationController(rootViewController: spotifyViewController)
        loginWebView.loginViewController = self
        
        self.present(loginWebView, animated: true, completion: nil)
    }
    
    @IBAction private func tapLoginButton(_ sender: UIButton) {
        spotifyAuthVC()
    }
    
}

extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Chỗ này em đang test nên các anh đừng check chỗ này :v
        if let code = navigationAction.request.queryString(after: Constants.responseQuery) {
            SpotifyService.shared.requestToken(code: code) { (error, token) in
                if error != nil {
                    print(error!)
                } else {
                    print("Data--------------------------")
                    print(token!)
                }
            }
        }
        decisionHandler(.allow)
    }
}


