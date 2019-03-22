//
//  CBSimpleTabButtonFactory.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 20/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBMenuTabButtonFactory: CBTabButtonFactory {
    private let menu: CBTabMenu
    private let menuItem = CBMenuTabItem()
    weak var presentationController: UIViewController?
    
    init(menu: CBTabMenu) {
        self.menu = menu
    }
    
    func buttons(forItems items: [UITabBarItem]) -> [CBTabBarButton] {
        var buttons: [CBTabBarButton] = items.map { CBFadeTabBarButton(item: $0) }
        if buttons.count >= menu.menuButtonIndex {
            let menuItem = CBMenuTabItem()
            menuItem.image = menu.icon ?? UIImage(named: "btnMenu", in: Bundle.resourseBundle, compatibleWith: nil)
            menuItem.tintColor = menu.menuColor
            let button = CBMenuButton(item: menuItem)
            let presenter = CBMenuPresenter(menu: menu)
            button.presenter = presenter
            presenter.menuButton = button
            presenter.presentationController = presentationController
            buttons.insert(button, at: menu.menuButtonIndex)
        }
        return buttons
    }
    
}
