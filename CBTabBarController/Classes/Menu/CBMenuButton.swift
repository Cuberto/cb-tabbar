//
//  CBMenuButton.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 20/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBMenuButton: CBBaseTabButton {
    
    private let btnSize: CGFloat = 60.0
    private let tabImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    private let bgView = UIView()
    var presenter: CBMenuPresenter?
    
    override var requiredSize: CGSize? {
        return CGSize(width: btnSize, height: btnSize)
    }
    
    override var tintColor: UIColor! {
        didSet {
            bgView.backgroundColor = tintColor
        }
    }
    
    override func configure() {
        super.configure()
        bgView.frame = CGRect(origin: .zero, size: CGSize(width: btnSize, height: btnSize))
        tabImage.frame = bgView.frame
        addSubview(bgView)
        addSubview(tabImage)
        bgView.layer.cornerRadius = btnSize / 2.0
        tabImage.isUserInteractionEnabled = false
        bgView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bgView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        tabImage.frame = bgView.frame
    }
    
    override func didUpdateItem() {
        tabImage.image = item?.image
    }
}

