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
    
    static let shared = UserRepository()
    
    private let spotifyService = SpotifyService()
    private let userSession = UserSession()
    private var accessToken: String? {
        return userSession.accessToken
    }
    
    func login(on webView: WKWebView) {
        guard let url = URL(string: URLs.authorization) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    func requestToken(with code: String, completion: @escaping (BaseResult<Token>?) -> Void) {
        UserSession.shared.saveCode(code)
        
        let key = APIKey.CLIENT_ID + ":" + APIKey.CLIENT_SECRET
        guard let keyBase64String = key.data(using: .utf8)?.base64EncodedString() else { return }
        
        let header = ["Authorization": "Basic " + keyBase64String]
        
        let parameters = [
            "grant_type": "authorization_code",
            "code": code,
            "redirect_uri": Constants.REDIRECT_URI
        ]
        
        let request = BaseRequest(URLs.token, .post, header: header, parameter: parameters)
        
        spotifyService.request(input: request) { (token: Token?, error) in
            if let error = error  {
                completion(.failure(error: error))
            } else if let token = token {
                UserSession.shared.saveToken(token)
                completion(.success(token))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getListOfNewReleases(limit: Int, offset: Int,completion: @escaping (BaseResult<SpotifySearch>?) -> Void) {
        guard let accessToken = accessToken else { return }
        
        let header = ["Authorization": "Bearer \(accessToken)"]
        let urlString = URLs.newReleases + "?offset=\(offset)&limit=\(limit)"
        
        let request = BaseRequest(urlString, .get, header: header)
        
        spotifyService.request(input: request) { (result: SpotifySearch?, error) in
            if let error = error  {
                completion(.failure(error: error))
            } else if let result = result {
                completion(.success(result))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
    
    func getListOfCurrentUserPlaylists(completion: @escaping (BaseResult<SpotifyObject<Playlist>>?) -> Void) {
        guard let accessToken = accessToken else { return }
        
        let header = ["Authorization": "Bearer \(accessToken)"]
        
        let request = BaseRequest(URLs.currentUserPlaylist, .get, header: header)
        
        spotifyService.request(input: request) { (result: SpotifyObject<Playlist>?, error) in
            if let error = error  {
                completion(.failure(error: error))
            } else if let result = result {
                completion(.success(result))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}


