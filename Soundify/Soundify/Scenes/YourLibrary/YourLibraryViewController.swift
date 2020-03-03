//
//  YourLibraryViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/28/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import WebKit

class YourLibraryViewController: UIViewController {
    @IBAction func logoutBarButtonClicked(_ sender: UIBarButtonItem) {
        UserSession.shared.clearUserData()
        clearCookies()
        guard let loginScene = AppStoryboard.login.instantiateInitialViewController() else { return }
        DispatchQueue.main.async {
            loginScene.modalPresentationStyle = .overFullScreen
            self.present(loginScene, animated: true)
        }
    }

    private func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                print("[WebCacheCleaner] Record \(record) deleted")
            }
        }
    }
}
