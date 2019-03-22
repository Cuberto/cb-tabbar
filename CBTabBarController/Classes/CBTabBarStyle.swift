//
//  CBTabBarStyle.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 22/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

public protocol CBExtendedTabItem {
    var attributedTitle: NSAttributedString? { get }
    var tintColor: UIColor? { get }
}

public extension CBExtendedTabItem {
    var attributedTitle: NSAttributedString? {
        return nil
    }
    var tintColor: UIColor? {
        return nil
    }
}

public protocol CBTabMenuItem {
    var title: String? { get }
    var attributedTitle: NSAttributedString? { get }
}

public struct CBTabMenu {
    let menuButtonIndex: Int
    let menuColor: UIColor
    let items: [CBTabMenuItem]
    let icon: UIImage?
    let callback: (UIViewController, CBTabMenuItem) -> Void
    
    public init(menuButtonIndex: Int,
                menuColor: UIColor,
                items: [CBTabMenuItem],
                icon: UIImage?,
                callback: @escaping (UIViewController, CBTabMenuItem) -> Void){
        self.menuButtonIndex = menuButtonIndex
        self.menuColor = menuColor
        self.items = items
        self.icon = icon
        self.callback = callback
    }
}

public enum CBTabBarStyle {
    case flashy
    case fade
    case gooey(menu: CBTabMenu)
}
