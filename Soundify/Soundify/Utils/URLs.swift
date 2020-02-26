//
//  URLs.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

struct URLs {
    private static let APIBaseAuthorizationUrl = "https://accounts.spotify.com/authorize"
    
    public static let authorization = APIBaseAuthorizationUrl + "?response_type=token&client_id=" + Constants.CLIENT_ID + "&scope=" + Constants.encodedScopes + "&redirect_uri=" + Constants.REDIRECT_URI + "&show_dialog=false"
    
    private static var APIBaseUrl = "https://api.spotify.com/v1"
    public static let user = APIBaseUrl + "/me"
}
