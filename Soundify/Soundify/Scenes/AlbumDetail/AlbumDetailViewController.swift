//
//  DetailViewController.swift
//  Soundify
//
//  Created by Viet Anh on 3/12/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit
import Reusable
import SDWebImage

final class AlbumDetailViewController: BaseDetailViewController {
    
    //MARK: - Detail View
    private lazy var detailView = TopDetailView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0), with: album)
    
    //MARK: - Variable for Table View
    var album: Album!
    private var totalTimeTrack = 0
    private var releaseDate = Date()
    private var artists: [Artis] = []
    private var tracks: [Track] = []
    private var copyrights: [Copyright] = []

    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        fetchAnAlbumDetail(album: self.album)
    }
    
    private func configView() {
        configDetailView()
        configTableView()
    }
    
    private func configDetailView() {
        view.addSubview(detailView)
        detailView.delegate = self
    }
    
    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = detailView.edgeInsets
        
        tableView.register(cellType: TextTableViewCell.self)
        tableView.register(cellType: TrackAlbumDetailTableViewCell.self)
        tableView.register(cellType: ArtistAlbumDetailTableViewCell.self)
        tableView.register(cellType: HeaderDetailAlbumTableViewCell.self)
    }
}

//MARK: - TopDetailViewDelegate
extension AlbumDetailViewController: TopDetailViewDelegate {
    
    func leftBarButtonItemClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        detailView.scrollViewDidScroll(scrollView)
    }
}

//MARK: - UserRepository
extension AlbumDetailViewController {
    
    private func fetchAnAlbumDetail(album: Album) {
        UserRepository.shared.getAnAlbumDetail(album: album) { [weak self] result in
            switch result {
            case .success(let result):
                if let albumDetail = result {
                    self?.getDataBack(albumDetail)
                }
            case .failure(let error):
                self?.showErrorAlert(message: error.debugDescription)
            default:
                break
            }
        }
    }
    
    private func getDataBack(_ albumDetail: AlbumDetail) {
        tracks = albumDetail.tracks.items
        copyrights = albumDetail.copyrights
        totalTimeTrack = albumDetail.tracks.items.reduce(0) { $0 + $1.durationMs }
        fetchSeveralArtistsDetail(artists: albumDetail.artists)
        releaseDate = albumDetail.releaseDate ?? Date()
    }
    
    private func fetchSeveralArtistsDetail(artists: [Artis]) {
        UserRepository.shared.getSeveralArtistsDetail(artists: artists) { [weak self] result in
            switch result {
            case .success(let result):
                if let artistsDetail = result {
                    self?.artists = artistsDetail.artists
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self?.showErrorAlert(message: error.debugDescription)
            default:
                break
            }
        }
    }
}

//MARK: - UITableViewDataSource
extension AlbumDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return tracks.count + 1
        case 2:
            return artists.count
        case 3:
            return copyrights.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as HeaderDetailAlbumTableViewCell
            cell.setUpView(with: album, releaseDate: releaseDate, artists: artists)
            return cell
            
        case 1:
            if indexPath.row < tracks.count {
                let cell = tableView.dequeueReusableCell(for: indexPath) as TrackAlbumDetailTableViewCell
                cell.setUpCell(with: tracks[indexPath.row])
                return cell
            } else {
                return setUpCellDate(tableView, cellForRowAt: indexPath)
            }
            
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ArtistAlbumDetailTableViewCell
            cell.setUpCell(with: artists[indexPath.row])
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(for: indexPath) as TextTableViewCell
            cell.setUpCell(with: copyrights[indexPath.row].text)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    private func setUpCellDate(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TextTableViewCell
        let date = "\(releaseDate.monthNameString) \(releaseDate.dateString), \(releaseDate.yearString)"
        let text = date + "\n\(tracks.count) songs • \(totalTimeTrack.msToSeconds.formatterOnlyMinuteAndSecond)"
        cell.setUpCell(with: text)
        return cell
    }
    
}

//MARK: - UITableViewDelegate
extension AlbumDetailViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return Constants.TableView.heightForRowHeaderDetail
        case 3:
            return Constants.TableView.heightForRowCopyright
        default:
            return Constants.TableView.heightForRowDetail
        }
        
    }
    
}
