//
//  ViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/24/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import WebKit

final class LoginViewController: UIViewController {
    private let repo = UserRepository()
    private let webView = LoginWebView()
    private let spotifyViewController = UIViewController()
    private lazy var loginWebView = UINavigationController(rootViewController: spotifyViewController)
    
    override func viewDidLoad() {
        setUpUILoginWebView()
        setUpBarButton()
    }

    
    @IBAction private func tapLoginButton(_ sender: UIButton) {
        popUpLoginView()
    }
    
    private func popUpLoginView() {
        repo.login(on: webView)
        self.present(loginWebView, animated: true, completion: nil)
        webView.reload()
    }
    
}

//MARK: - SetUp LoginNavigationController
extension LoginViewController {
    private func setUpUILoginWebView() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        loginWebView.navigationBar.titleTextAttributes = textAttributes
        
        loginWebView.navigationBar.isTranslucent = false
        loginWebView.navigationBar.tintColor = UIColor.white
        loginWebView.navigationBar.barTintColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        loginWebView.modalPresentationStyle = .overFullScreen
        
        spotifyViewController.view.addSubview(webView)
        
        webView.navigationDelegate = self
        webView.setupUI(on: spotifyViewController)
    }
    
    private func setUpBarButton() {
        spotifyViewController.navigationItem.title = "spotify.com"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        spotifyViewController.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        spotifyViewController.navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc private func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshAction() {
        self.webView.reload()
    }
}

//MARK: - WKNavigationDelegate
extension LoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // Chỗ này em đang test nên các anh đừng check chỗ này :v
        if let code = navigationAction.request.queryString(after: Constants.responseQuery) {
            repo.requestToken(code: code) { result in
                switch result {
                case .success(let token):
                    print(token ?? "Nil")
                case .failure(let error):
                    print(error ?? "Error")
                default:
                    break
                }
            }
        }
        decisionHandler(.allow)
    }
}
