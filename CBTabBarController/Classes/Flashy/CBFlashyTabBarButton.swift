//
//  CBTabBarButton.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

class CBFlashyTabBarButton: CBTabBarButton {

    var tabImage = UIImageView()
    var tabLabel = UILabel()
    var badgeContainer = UIView()
    var badgeLabel = UILabel()
    var dotView = UIView()
    
    var selectAnimation: CBTabItemAnimation?
    var deselectAnimation: CBTabItemAnimation?
    var config: CBFlashyTabBarConfig?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
        addObservers()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureSubviews()
        addObservers()
    }

    required init(item: UITabBarItem) {
        super.init(frame: .zero)
        addObservers()
        configureSubviews()
        self.item = item
    }
    
    deinit {
        removeObserver(self, forKeyPath: #keyPath(_item.badgeValue))
        removeObserver(self, forKeyPath: #keyPath(_item.badgeColor))
    }
    
    private func addObservers() {
        addObserver(self, forKeyPath: #keyPath(_item.badgeValue), options: [.initial, .new], context: nil)
        addObserver(self, forKeyPath: #keyPath(_item.badgeColor), options: [.initial, .new], context: nil)
    }
    
    var item: UITabBarItem? {
        set {
            guard let item = newValue else { return }
            _item = item
        }
        get {
            return _item
        }
    }
    
    @objc dynamic var _item: UITabBarItem = UITabBarItem(){
        didSet {
            didUpdateItem()
        }
    }

    override var tintColor: UIColor! {
        didSet {
            tabImage.tintColor = tintColor.withAlphaComponent(config?.deselectedOpacity ?? 0.4)
            tabLabel.attributedText = (item as? CBExtendedTabItem)?.attributedTitle ?? attributedText(fortitle: item?.title)
            dotView.backgroundColor = tintColor
            badgeContainer.backgroundColor = item?.badgeColor ?? tintColor
        }
    }

    private func attributedText(fortitle title: String?) -> NSAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [:]
        attrs[.kern] = -0.2
        attrs[.foregroundColor] = tintColor
        attrs[.font] = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return NSAttributedString(string: title ?? "", attributes: attrs)
    }

    private func configureSubviews() {
        addSubview(tabLabel)
        addSubview(tabImage)
        addSubview(dotView)
        badgeContainer.addSubview(badgeLabel)
        addSubview(badgeContainer)
        tabLabel.numberOfLines = 2
        tabLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        tabLabel.isHidden = true
        tabImage.contentMode = .center
        let dotSize: CGFloat = 5.0
        dotView.frame = CGRect(origin: .zero, size: CGSize(width: dotSize, height: dotSize))
        dotView.layer.cornerRadius = dotSize / 2.0
        dotView.layer.shouldRasterize = true
        dotView.layer.rasterizationScale = UIScreen.main.scale
        dotView.isHidden = true
        badgeContainer.isHidden = true
        badgeLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        badgeLabel.textColor = .white
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tabImage.sizeToFit()
        tabImage.center = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
        tabLabel.frame = bounds
        tabLabel.sizeToFit()
        tabLabel.center = tabImage.center
        let dotX: CGFloat = tabImage.center.x - dotView.frame.width/2.0
        let dotY: CGFloat = tabLabel.frame.maxY + 13.0
        dotView.frame = CGRect(origin: CGPoint(x: dotX, y: dotY), size: dotView.frame.size)
        
        let badgeMargin: CGFloat = 3
        badgeLabel.sizeToFit()
        let badgeWidth = max(20, min(badgeLabel.frame.width + 2 * badgeMargin, bounds.width - 2 * badgeMargin))
        badgeContainer.frame = CGRect(x: min(bounds.width - badgeWidth - badgeMargin, tabLabel.frame.maxX),
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

    func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            select(animated: animated)
        } else {
            deselect(animated: animated)
        }
    }

    func select(animated: Bool = true) {
        guard !_isSelected else {
            return
        }
        _isSelected = true
        guard animated, let selectAnimation = selectAnimation else {
            tabLabel.isHidden = false
            tabImage.isHidden = true
            dotView.isHidden = false
            return
        }
        tabLabel.isHidden = false
        dotView.isHidden = false
        selectAnimation.playAnimation(forTabBarItem: self) {[weak self] in
            if self?._isSelected ?? false {
                self?.tabImage.isHidden = true
            }
        }
    }

    func deselect(animated: Bool = true) {
        guard _isSelected else {
            return
        }
        _isSelected = false
        guard animated, let deselectAnimation = deselectAnimation else {
                tabLabel.isHidden = true
                tabImage.isHidden = false
                dotView.isHidden = true
                return
        }
        tabImage.isHidden = false
        deselectAnimation.playAnimation(forTabBarItem: self) {[weak self] in
            if !(self?._isSelected ?? true) {
                self?.tabLabel.isHidden = true
                self?.dotView.isHidden = true
            }
        }
    }
    
    private func didUpdateItem() {
        tabImage.image = item?.image?.withRenderingMode(.alwaysTemplate)
        tabLabel.attributedText = (item as? CBExtendedTabItem)?.attributedTitle ?? attributedText(fortitle: item?.title)
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
