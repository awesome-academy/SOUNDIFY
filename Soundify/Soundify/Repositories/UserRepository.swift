//
//  UserRepository.swift
//  Soundify
//
//  Created by Viet Anh on 2/27/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation
import WebKit

struct UserRepository {
    
    func login(on webView: WKWebView) {
        let urlRequest = URLRequest.init(url: URL.init(string: URLs.authorization)!)
        webView.load(urlRequest)
    }
    
    func requestToken (code: String, completion: @escaping (BaseResult<RefreshTokenResponse>?) -> Void) {
        let key = APIKey.CLIENT_ID + ":" + APIKey.CLIENT_SECRET
        guard let keyBase64String = key.data(using: .utf8)?.base64EncodedString() else { return }
        
        let header = ["Authorization": "Basic " + keyBase64String]
        
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.REDIRECT_URI
        ]
        
        let request = BaseRequest(URLs.token, .post, header: header, parameter: parameters)
        
        SpotifyService.shared.requestPost(request: request) { (object: RefreshTokenResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}


