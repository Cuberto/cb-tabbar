//
//  CBFlashyTabBarController.swift
//  CBFlashyTabBarController
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

open class CBTabBarController: UITabBarController {

    fileprivate var shouldSelectOnTabBar = true
    
    public var style: CBTabBarStyle = .fade {
        didSet {
            updateTabBarStyle()
        }
    }

    open override var selectedViewController: UIViewController? {
        willSet {
            guard shouldSelectOnTabBar,
                  let newValue = newValue else {
                shouldSelectOnTabBar = true
                return
            }
            guard let tabBar = tabBar as? CBTabBar, let index = viewControllers?.index(of: newValue) else {
                return
            }
            tabBar.select(itemAt: index, animated: false)
        }
    }

    open override var selectedIndex: Int {
        willSet {
            guard shouldSelectOnTabBar else {
                shouldSelectOnTabBar = true
                return
            }
            guard let tabBar = tabBar as? CBTabBar else {
                return
            }
            tabBar.select(itemAt: selectedIndex, animated: false)
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        defer {
            updateTabBarStyle()
        }
        guard self.tabBar as? CBTabBar == nil else {
            return
        }
        let tabBar = CBTabBar()
        if let barTint = self.tabBar.barTintColor {
            tabBar.barTintColor = barTint
        }
        self.setValue(tabBar, forKey: "tabBar")
    }
    
    private func updateTabBarStyle() {
        switch style {
        case .fade:
            (self.tabBar as? CBTabBar)?.buttonFactory = CBFadeTabButtonFactory()
        case .flashy:
            (self.tabBar as? CBTabBar)?.buttonFactory = CBFlashyTabButtonFactory()
        case let .gooey(menu):
            let menuFactory = CBMenuTabButtonFactory(menu: menu)
            menuFactory.presentationController = self
            tabBar.layer.borderWidth = 0.0
            tabBar.clipsToBounds = true
            (self.tabBar as? CBTabBar)?.buttonFactory = menuFactory
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private var _barHeight: CGFloat = 74
    open var barHeight: CGFloat {
        get {
            if #available(iOS 11.0, *) {
                return _barHeight + view.safeAreaInsets.bottom
            } else {
                return _barHeight
            }
        }
        set {
            _barHeight = newValue
            updateTabBarFrame()
        }
    }

    private func updateTabBarFrame() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = barHeight
        tabFrame.origin.y = self.view.frame.size.height - barHeight
        self.tabBar.frame = tabFrame
        tabBar.setNeedsLayout()
    }

    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateTabBarFrame()
    }

    open override func viewSafeAreaInsetsDidChange() {
        if #available(iOS 11.0, *) {
            super.viewSafeAreaInsetsDidChange()
        }
        updateTabBarFrame()
    }

    open override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let idx = tabBar.items?.index(of: item) else {
            return
        }
        if let controller = viewControllers?[idx] {
            shouldSelectOnTabBar = false
            selectedIndex = idx
            delegate?.tabBarController?(self, didSelect: controller)
        }
    }

}
