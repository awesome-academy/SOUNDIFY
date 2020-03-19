//
//  TrackDetailViewController.swift
//  Soundify
//
//  Created by Viet Anh on 3/17/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import AVFoundation

final class TrackDetailViewController: BaseDetailViewController {
    
    //MARK: - IBOutlet
    @IBOutlet private weak var aboveSafeArea: UIView!
    
    ///Image
    @IBOutlet private weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var trackImageView: UIImageView!
    
    ///For track
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var artistsNameLabel: UILabel!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var audioSlider: UISlider!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    
    //MARK: - Track
    var track: Track!
    private let navigationBar = TrackDetailNavigationBarView()
    
    //MARK: - Variable for playing song
    private var player: AVPlayer?
    
    private var totalTime: Float { Float(player?.currentItem?.duration.seconds ?? 1) }
    private var isPlaying: Bool {
        get { player?.rate != 0 && player?.error == nil }
        set {
            switch newValue {
            case true:
                player?.play()
                playButton.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            case false:
                player?.pause()
                playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
            }
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
}

//MARK: - ConfigView
extension TrackDetailViewController {
    
    private func configView() {
        getAudio()
        configBackground()
        configImageView()
        navigationBar.configView(on: self, aboveSafeArea: aboveSafeArea, with: track)
    }
    
    private func configBackground() {
        view.setGradientBackground(colorTop: #colorLiteral(red: 0.1450815201, green: 0.1451086104, blue: 0.1450755298, alpha: 1), colorBottom: #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1))
        trackNameLabel.text = track.name
        artistsNameLabel.text = track.artists.sequenceNameArtistsWithComma
    }
    
    private func configImageView() {
        trackImageView.do {
            $0.sd_setImage(with: track.album?.images.urlImage, completed: nil)
            $0.borderColor = .lightGray
            $0.borderWidth = 1
            $0.cornerRadius = 10
        }
        
        backgroundImageView.do {
            $0.sd_setImage(with: track.album?.images.urlImage, completed: nil)
            $0.alpha = 0.1
        }
    }
    
    private func getAudio() {
        guard let url = URL(string: track.previewUrl ?? "") else {
            artistsNameLabel.do {
                $0.numberOfLines = 0
                if let text = $0.text { $0.text = "\(text)\n No preview Url" }
            }
            return
        }
        
        
        player = AVPlayer(playerItem: AVPlayerItem(url: url) ).then {
            $0.play()
            let interval = CMTime(value: 1, timescale: 1000)
            $0.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (currentTime) in
                if self?.totalTime.isNaN ?? true { return }
                self?.configLabelTime(at: currentTime)
                self?.playbackWhenFinishSong()
            }
        }
        
        playSongWhenEnterBackground()
    }
    
    private func configLabelTime(at currentTime: CMTime) {
        audioSlider.value = Float(currentTime.seconds) / (totalTime)
        totalTimeLabel.text = Double(totalTime).formatterMinuteAndSecondInTrack
        currentTimeLabel.text = currentTime.seconds.formatterMinuteAndSecondInTrack
    }
    
    private func playbackWhenFinishSong() {
        if currentTimeLabel.text == totalTimeLabel.text {
            player?.seek(to: CMTime(seconds: 0, preferredTimescale: 1000))
            player?.play()
        }
    }
    
    private func playSongWhenEnterBackground() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch {
            print(error)
        }
    }
}

//MARK: - IBAction
extension TrackDetailViewController {
    
    @IBAction func sliderValueChanged(_ sender: UISlider, forEvent event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            let currentTime = Double(sender.value * self.totalTime)
            isPlaying = false
            switch touchEvent.phase {
            case .moved:
                DispatchQueue.main.async {
                    self.currentTimeLabel.text = currentTime.formatterMinuteAndSecondInTrack
                }
                break
                
            case .ended:
                player?.seek(to: CMTime(seconds: currentTime, preferredTimescale: 1000))
                isPlaying = true
                break
                
            default:
                break
            }
        }
    }
    
    @IBAction func playButtonClicked(_ sender: UIButton) {
        isPlaying.toggle()
    }
}
