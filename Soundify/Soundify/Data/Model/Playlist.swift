//
//  Playlist.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

// https://developer.spotify.com/documentation/web-api/reference/object-model/#playlist-object-full
// Khi decode phải convertFromSnakeCase bởi vì dạng Json ví dụ: external_urls
// let decoder = JSONDecoder()
// decoder.keyDecodingStrategy = .convertFromSnakeCase
struct Playlist: BaseModel {
    let description: String
    let externalUrls: ExternalUrl
    let followers: Follower
    let href: String
    let id: String
    let image: [Image]
    let name: String
    let tracks: [Track]
    let type: String
    let uri: String
}
