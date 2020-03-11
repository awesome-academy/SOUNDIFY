//
//  SearchViewController.swift
//  Soundify
//
//  Created by Viet Anh on 2/29/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private let itemsSegmented = ["Tracks", "Artists", "Albums", "Playlist"]
    private var switchSegment = true {
        didSet {
            segmentedControl.isHidden = switchSegment
            buttonBar.isHidden = switchSegment
        }
    }
    
    private lazy var segmentedControl = SearchSegmentedControl(items: itemsSegmented)
    private lazy var searchController = UISearchController()
    private lazy var buttonBar = ButtonBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configView()
        switchSegment = true
    }
    
}

//MARK: - SetUpView and ConfigView
extension SearchViewController {
    private func configView() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func setUpView() {
        setUpSearchBarViewController()
        
        view.addSubview(segmentedControl)
        segmentedControl.setUpView()
        segmentedControl.setUpConstraints(on: self)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)),  for: .valueChanged)
        
        view.addSubview(buttonBar)
        buttonBar.setUpConstraints(on: self, hasSegmentedControl: segmentedControl)
    }

    private func setUpSearchBarViewController() {
        let appearance = UINavigationBarAppearance()
        
        let attributedString: [NSAttributedString.Key: Any] =
            [.foregroundColor : UIColor.white]
        
        appearance.titleTextAttributes = attributedString
        appearance.backgroundColor =  #colorLiteral(red: 0.1450815201, green: 0.1451086104, blue: 0.1450755298, alpha: 1)
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        let searchField = searchController.searchBar.searchTextField
        searchField.tintColor = .black
        searchField.backgroundColor = .white
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            let originX = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
            self.buttonBar.frame.origin.x = originX
        }
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        switchSegment = false
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        switchSegment = true
    }
}

