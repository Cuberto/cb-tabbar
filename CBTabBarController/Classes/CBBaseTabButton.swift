//
//  CBBaseTabButton.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 20/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBBaseTabButton: UIButton, CBTabBarButtonProtocol  {
    
    var badgeContainer = UIView()
    var badgeLabel = UILabel()
    var item: UITabBarItem? {
        set {
            guard let item = newValue else { return }
            _item = item
        }
        get {
            return _item
        }
    }
    
    @objc dynamic var _item: UITabBarItem = UITabBarItem() {
        didSet {
            didUpdateItem()
        }
    }
    
    var requiredSize: CGSize? {
        return nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        addObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        addObservers()
    }
    
    required init(item: UITabBarItem) {
        super.init(frame: .zero)
        configure()
        addObservers()
        self.item = item
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(_item.badgeValue))
        removeObserver(self, forKeyPath: #keyPath(_item.badgeColor))
    }
    
    func addObservers() {
        addObserver(self, forKeyPath: #keyPath(_item.badgeValue), options: [.initial, .new], context: nil)
        addObserver(self, forKeyPath: #keyPath(_item.badgeColor), options: [.initial, .new], context: nil)
    }
    
    func configure() {
        badgeContainer.isHidden = true
        badgeContainer.addSubview(badgeLabel)
        addSubview(badgeContainer)
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        badgeLabel.textColor = .white
    }
    
    override var tintColor: UIColor! {
        didSet {
            badgeContainer.backgroundColor = item?.badgeColor ?? tintColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let badgeMargin: CGFloat = 3
        badgeLabel.sizeToFit()
        let badgeWidth = max(20, min(badgeLabel.frame.width + 2 * badgeMargin, bounds.width - 2 * badgeMargin))
        badgeContainer.frame = CGRect(x: min(bounds.width - badgeWidth - badgeMargin,
                                             max(titleLabel?.frame.maxX ?? 0, imageView?.frame.maxX ?? 0)),
                                      y: badgeMargin,
                                      width: badgeWidth,
                                      height: 20)
        let lblWidth = min(badgeLabel.frame.width, badgeWidth - 2 * badgeMargin)
        badgeLabel.frame = CGRect(x: (badgeContainer.frame.width - lblWidth)/2.0,
                                  y: badgeMargin,
                                  width: lblWidth,
                                  height: badgeContainer.frame.height - 2 * badgeMargin)
        badgeContainer.layer.cornerRadius = badgeContainer.frame.height/2.0
    }
    
    private var _isSelected: Bool = false
    override var isSelected: Bool {
        get {
            return _isSelected
        }
        set {
            guard newValue != _isSelected else {
                return
            }
            if newValue {
                select(animated: false)
            } else {
                deselect(animated: false)
            }
        }
    }
    
    func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            select(animated: animated)
        } else {
            deselect(animated: animated)
        }
    }
    
    func select(animated: Bool = true) {
    }
    
    func deselect(animated: Bool = true) {
    }
    
    func didUpdateItem() {
        badgeContainer.backgroundColor = item?.badgeColor ?? tintColor
        badgeLabel.text = item?.badgeValue
        badgeContainer.isHidden = item?.badgeValue == nil
        setNeedsLayout()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case #keyPath(_item.badgeValue), #keyPath(_item.badgeColor):
            didUpdateItem()
        default:
            break
        }
    }
}
