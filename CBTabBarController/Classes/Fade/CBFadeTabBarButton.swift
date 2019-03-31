//
//  CBSimpleTabBarButton.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 20/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBFadeTabBarButton: CBBaseTabButton {
    
    private let deselectedAlpha: CGFloat = 0.5
    private let animationDuration: Double = 0.15
    
    override func configure() {
        super.configure()
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.alpha = _isSelected ? 1 : deselectedAlpha
        titleLabel?.alpha = _isSelected ? 1 : deselectedAlpha
    }
    
   override func select(animated: Bool = true) {
        guard !_isSelected else {
            return
        }
        _isSelected = true
        let animation: () -> Void = {[weak self] in
            self?.imageView?.alpha = 1
            self?.titleLabel?.alpha = 1
        }
        guard animated else {
            animation()
            return
        }
        UIView.animate(withDuration: animationDuration, animations: animation)
    }
    
    override func deselect(animated: Bool = true) {
        guard _isSelected else {
            return
        }
        _isSelected = false
        let animation: () -> Void = {[weak self] in
            self?.imageView?.alpha = self?.deselectedAlpha ?? 0
            self?.titleLabel?.alpha = self?.deselectedAlpha ?? 0
        }
        guard animated else {
            animation()
            return
        }
        UIView.animate(withDuration: animationDuration, animations: animation)
    }
    
    override func didUpdateItem() {
        super.didUpdateItem()
        setImage(item?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        setNeedsLayout()
    }
}
