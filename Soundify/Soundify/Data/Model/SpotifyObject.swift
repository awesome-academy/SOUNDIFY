//
//  SpotifyObject.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

//https://developer.spotify.com/documentation/web-api/reference/object-model/#paging-object
struct SpotifyObject<T: BaseModel>: BaseModel {
    let href: String
    let items: [T]?
    let limit: Int
    let next: String
    let offset: Int
    let previous: String
    let total: Int
}
