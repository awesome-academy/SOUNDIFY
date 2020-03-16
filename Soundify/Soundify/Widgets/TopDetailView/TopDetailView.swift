//
//  TopDetailView.swift
//  Soundify
//
//  Created by Viet Anh on 3/15/20.
//  Copyright © 2020 VietAnh. All rights reserved.
//

import UIKit

protocol TopDetailViewDelegate: AnyObject {
    func leftBarButtonItemClicked()
    func scrollViewDidScroll(_ scrollView: UIScrollView)
}

class TopDetailView: UIView {
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(frame: CGRect ,with album: Album) {
        self.init(frame: frame)
        setUpDetailView(with: album)
    }
    
    convenience init(frame: CGRect ,with playlist: Playlist) {
        self.init(frame: frame)
        setUpDetailView(with: playlist)
    }
    
    private let nibName = "TopDetailView"
    private func commonInit() {
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        addSubview(contentView)
    }

    //MARK: - IBOutlet & IBAction
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var imageTopSpace: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBAction private func backButtonClicked(_ sender: UIButton) {
        delegate?.leftBarButtonItemClicked()
    }

    //MARK: - Variable for Stretchy Header Effect
    /// Delegate
    weak var delegate: TopDetailViewDelegate?
    
    /// Public
    let edgeInsets = UIEdgeInsets(top: 270, left: 0, bottom: 0, right: 0)
    
    /// Private
    private let viewHeight: CGFloat = 270
    private var isHiddenTitleNavigation = true
    private let topAlignmentConstraintImageView: CGFloat = 15
    private let screenHeight = UIScreen.main.bounds.size.height
    private let screenWidth = UIScreen.main.bounds.size.width
    private var navigationBarHeight: CGFloat {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let height = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return height
    }
    
    //MARK: - Setup View
    
    private func setUpDetailView(with album: Album) {
        navigationBarView.setGradientBackground(colorTop: #colorLiteral(red: 0.1450815201, green: 0.1451086104, blue: 0.1450755298, alpha: 1), colorBottom: #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1))
        titleLabel.text = album.name
        titleLabel.alpha = 0.0
        if let url = URL(string: album.images.first?.url ?? "") {
            albumImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func setUpDetailView(with playlist: Playlist) {
        navigationBarView.setGradientBackground(colorTop: #colorLiteral(red: 0.1450815201, green: 0.1451086104, blue: 0.1450755298, alpha: 1), colorBottom: #colorLiteral(red: 0.09718047827, green: 0.07773689181, blue: 0.07808386534, alpha: 1))
        titleLabel.text = playlist.name
        titleLabel.alpha = 0.0
        if let url = URL(string: playlist.images.first?.url ?? "") {
            albumImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    //MARK: - For scrollViewDidScroll
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = viewHeight - (scrollView.contentOffset.y + viewHeight)
        changeAlphaTitle(at: y)
        changePositionImage(at: y)
    }
    
    private func changeAlphaTitle(at yPosition: CGFloat) {
        
        if yPosition >= navigationBarHeight - topAlignmentConstraintImageView {
            if !isHiddenTitleNavigation {
                isHiddenTitleNavigation = true
                UIView.animate(withDuration: 0.1) { self.titleLabel.alpha = 0.0 }
            }
        } else if isHiddenTitleNavigation {
            isHiddenTitleNavigation = false
            UIView.animate(withDuration: 0.1) { self.titleLabel.alpha = 1.0 }
        }
    }
    
    private func changePositionImage(at yPosition: CGFloat) {
        
        let position = min(max(yPosition, navigationBarHeight), screenHeight)
        
        frame = CGRect(x: 0, y: navigationBarHeight, width: screenWidth, height: position)

        if yPosition >= viewHeight {
            albumImageView.transform = CGAffineTransform(scaleX: (yPosition/viewHeight), y: (yPosition/viewHeight))
            imageTopSpace.constant = topAlignmentConstraintImageView
        } else {
            imageTopSpace.constant =
                (yPosition - (viewHeight - topAlignmentConstraintImageView)) + ((yPosition - viewHeight) * 0.6)
        }
    }
    
}
