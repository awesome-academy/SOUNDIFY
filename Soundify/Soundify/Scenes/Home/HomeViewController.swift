//
//  HomeViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/29/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    private var total = 0
    private var limit = 20
    private var offset = 0
    
    private var items: [Album] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchListOfNewReleases()
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: Cell.homeTableView, bundle: nil),
                            forCellReuseIdentifier: Cell.homeTableView)
    }
    
    private func fetchListOfNewReleases() {
        UserRepository.shared.getListOfNewReleases(limit: limit, offset: offset) { [weak self] result in
            switch result {
            case .success(let result):
                guard let albums = result?.albums else { return }
                self?.items += albums.items
                self?.total = albums.total
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
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
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.homeTableView) as? HomeTableViewCell else { return UITableViewCell() }
        if indexPath.row == self.items.count - 1 {
            self.loadMore()
        }
        cell.setUpCell(with: items[indexPath.row])
        return cell
    }
    
    private func loadMore() {
        if offset + limit <= total {
            offset += limit
            fetchListOfNewReleases()
        } else if offset != total {
            offset = total
            fetchListOfNewReleases()
        }
    }
}

//MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderView(frame: tableView.frame, title: Constants.headerTitle.newRelease)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.tableView.heightForHeaderInSection
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.tableView.heightForRow
    }
}
