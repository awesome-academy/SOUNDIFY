//
//  HomeViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/29/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private var albums: [Album]?
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        fetchListOfNewReleases()
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: Cell.homeTableView, bundle: nil),
                            forCellReuseIdentifier: Cell.homeTableView)
    }
    
    private func fetchListOfNewReleases() {
        UserRepository.shared.getListOfNewReleases(limit: nil, offset: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                if let albums = result?.albums?.items {
                    self.albums = albums
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                self.showErrorAlert(message: error.debugDescription)
            default:
                break
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let size = albums?.count {
            return size
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.homeTableView)
        if let cell = cell as? HomeTableViewCell {
            cell.album = albums?[indexPath.row]
            cell.setUpCell()
            return cell
        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110.0
    }
}
