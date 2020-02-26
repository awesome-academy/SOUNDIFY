//
//  Constants.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

struct Constants {
    public static let REDIRECT_URI = "soundify://"
    
    private static let scopes = ["user-modify-playback-state", "user-top-read", "playlist-read-private", "playlist-modify-private", "user-read-private", "playlist-read-collaborative", "user-library-read",]
    
    public static var encodedScopes: String {
        return scopes.joined(separator: "%20")
    }
}
