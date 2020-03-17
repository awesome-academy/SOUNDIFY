//
//  TrackPlaylistDetailTableViewCell.swift
//  Soundify
//
//  Created by Viet Anh on 3/16/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import Reusable

class TrackPlaylistDetailTableViewCell: UITableViewCell, Reusable {

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var artistsLabel: UILabel!
    
    var detailTrack: PlaylistDetailTrack! {
        didSet {
            backgroundColor = #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1)
            let track = detailTrack.track
            nameLabel.text = track.name
            artistsLabel.text = track.artists.sequenceNameArtistsWithComma
            trackImageView.sd_setImage(with: track.album?.images.urlImage, completed: nil)
        }
    }

}
