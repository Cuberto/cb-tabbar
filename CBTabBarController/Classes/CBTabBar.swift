//
//  CBFlashyTabBar.swift
//  CBFlashyTabBarController
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

open class CBTabBar: UITabBar {

    private var buttons: [CBTabBarButton] = []

    fileprivate var shouldSelectOnTabBar = true
    var buttonFactory: CBTabButtonFactory? {
        didSet {
            reloadViews()
        }
    }
    
    open override var selectedItem: UITabBarItem? {
        willSet {
            guard let newValue = newValue else {
                buttons.forEach { $0.setSelected(false, animated: false) }
                return
            }
            
            let btnItems: [UITabBarItem?] = buttons.map { $0.item }
            for (index, value) in btnItems.enumerated() {
                if value === newValue {
                    select(itemAt: index, animated: false)
                }
            }
        }
    }

    open override var tintColor: UIColor! {
        didSet {
            buttons.forEach { button in
                if let item = button.item as? CBExtendedTabItem {
                    button.tintColor = item.tintColor ?? tintColor
                } else {
                    button.tintColor = tintColor
                }
            }
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    private func configure() {
        backgroundColor = UIColor.white
        isTranslucent = false
        barTintColor = UIColor.white
    }

    open override var items: [UITabBarItem]? {
        didSet {
            reloadViews()
        }
    }

    open override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        super.setItems(items, animated: animated)
        reloadViews()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let sizedButtons = buttons.filter { $0.requiredSize != nil }
        let minWidth = bounds.width / CGFloat(buttons.count)
        let predefinedWidth: CGFloat = sizedButtons.compactMap { $0.requiredSize?.width }
                                                   .map { max(minWidth, $0) }
                                                   .reduce(0, +)
    
        let btnWidth = max(0, (bounds.width - predefinedWidth) / CGFloat(buttons.count - sizedButtons.count))
        let bottomOffset: CGFloat
        if #available(iOS 11.0, *) {
            bottomOffset = safeAreaInsets.bottom/2.0
        } else {
            bottomOffset = 0
        }
        let btnHeight = bounds.height - bottomOffset
        
        var lastX: CGFloat = 0
        for button in buttons {
            var padding: CGFloat = 0
            if let btnSize = button.requiredSize {
                let btnY = (btnHeight - btnSize.height)/2.0
                padding = max(0, (minWidth - btnSize.width)/2.0)
                button.frame = CGRect(origin: CGPoint(x: lastX + padding, y: btnY),
                                      size: btnSize)
            } else {
                button.frame = CGRect(x: lastX, y: 0, width: btnWidth, height: btnHeight)
            }
            lastX = button.frame.maxX + padding
            button.setNeedsLayout()
        }
    }

    private func reloadViews() {
        subviews.filter { String(describing: type(of: $0)) == "UITabBarButton" }.forEach { $0.removeFromSuperview() }
        buttons.forEach { $0.removeFromSuperview()}
        buttons = buttonFactory?.buttons(forItems: items ?? []) ?? []
        buttons.forEach { button in
            if let item = button.item as? CBExtendedTabItem {
                button.tintColor = item.tintColor ?? tintColor
            } else {
                button.tintColor = tintColor
            }
            if selectedItem != nil && button.item === selectedItem {
                button.setSelected(true, animated: false)
            }
            button.addTarget(self, action: #selector(btnPressed), for: .touchUpInside)
            addSubview(button)
        }
        setNeedsLayout()
    }

    @objc private func btnPressed(sender: UIControl) {
        guard let sender = sender as? CBTabBarButton else {
            return
        }
        
        buttons.forEach { (button) in
            guard button !== sender else {
                return
            }
            button.setSelected(false, animated: true)
        }
        sender.setSelected(true, animated: true)
        if let item = sender.item,
           let items = items,
           items.contains(item) {
            delegate?.tabBar?(self, didSelect: item)
        }
    }

    func select(itemAt index: Int, animated: Bool = false) {
        guard index < buttons.count else {
            return
        }
        let selectedbutton = buttons[index]
        buttons.forEach { (button) in
            guard button !== selectedbutton else {
                return
            }
            button.setSelected(false, animated: false)
        }
        selectedbutton.setSelected(true, animated: false)
    }

}
