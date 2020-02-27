//
//  LoginWebViewNavigationController.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

class LoginWebViewNavigationController: UINavigationController {
    weak var loginViewController: LoginViewController?
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUpUI()
        setUpBarButton(on: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = #colorLiteral(red: 0.1137254902, green: 0.7254901961, blue: 0.3294117647, alpha: 1)
        modalPresentationStyle = .overFullScreen
    }
    
    private func setUpBarButton(on rootViewController: UIViewController) {
        rootViewController.navigationItem.title = "spotify.com"
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: loginViewController, action: #selector(self.cancelAction))
        rootViewController.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: loginViewController, action: #selector(self.refreshAction))
        rootViewController.navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc private func cancelAction() {
        loginViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshAction() {
        loginViewController?.webView.reload()
    }
}
