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
        guard let tabBar = tabBar as? CBTabBar else {
            return
        }
        style.configure(tabBar: tabBar, with: self)
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    open var barHeight: CGFloat {
        get {
            return (tabBar as? CBTabBar)?.barHeight ?? tabBar.frame.height
        }
        set {
            (tabBar as? CBTabBar)?.barHeight = newValue
            self.setValue(tabBar, forKey: "tabBar")
        }
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
    
    private func updateTabBarFrame() {
        var tabFrame = tabBar.frame
        if #available(iOS 11.0, *) {
            tabFrame.size.height = barHeight + view.safeAreaInsets.bottom
        } else {
            tabFrame.size.height = barHeight
        }
        tabFrame.origin.y = self.view.frame.size.height - tabFrame.size.height
        tabBar.frame = tabFrame
        tabBar.setNeedsLayout()
    }
    
    @available(iOS 11.0, *)
    open override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        updateTabBarFrame()
    }
}
