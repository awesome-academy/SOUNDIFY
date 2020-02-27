//
//  SpotifyService.swift
//  Soundify
//
//  Created by Viet Anh on 2/25/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation
import WebKit

typealias Parameter = [String: Any]

struct SpotifyService {
    static let shared = SpotifyService()
    
    func login(on webView: WKWebView) {
        let urlRequest = URLRequest.init(url: URL.init(string: URLs.authorization)!)
        webView.load(urlRequest)
    }
    
    func requestToken (code: String, completion: @escaping (Error?, RefreshTokenResponse?) -> Void) {
        let key = APIKey.CLIENT_ID + ":" + APIKey.CLIENT_SECRET
        let keyBase64String = key.data(using: .utf8)?.base64EncodedString()
        
        let parameters: Parameter = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.REDIRECT_URI
        ]
        
        let url = URL(string: URLs.token)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Basic " + keyBase64String!, forHTTPHeaderField: "Authorization")
        request.httpBody = parameters.percentEncoded()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            if (error != nil) {
                completion(error,nil)
            } else {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let result = try? decoder.decode(RefreshTokenResponse.self, from: data!) {
                    completion(nil,result)
                } else {
                    completion(nil,nil)
                }
            }
        }
        task.resume()
    }
}
