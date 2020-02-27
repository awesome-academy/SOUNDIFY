//
//  SpotifySearchResponse.swift
//  Soundify
//
//  Created by Viet Anh on 2/26/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import Foundation

struct SpotifySearchResponse: Codable {
    var albums: SpotifyObject<Album>?
    var artists: SpotifyObject<Artis>?
    var tracks: SpotifyObject<Track>?
    var playlists: SpotifyObject<Playlist>?
    
    var numberOfSections: Int {
        var total = 0
        
        if let items = albums?.items, !items.isEmpty {
            total += 1
            if albums?.next != nil {
                total += 1
            }
        }
        if let items = artists?.items, !items.isEmpty {
            total += 1
            if artists?.next != nil {
                total += 1
            }
        }
        if let items = tracks?.items, !items.isEmpty {
            total += 1
            if tracks?.next != nil {
                total += 1
            }
        }
        if let items = playlists?.items, !items.isEmpty {
            total += 1
            if playlists?.next != nil {
                total += 1
            }
        }
        
        return total
    }
}
