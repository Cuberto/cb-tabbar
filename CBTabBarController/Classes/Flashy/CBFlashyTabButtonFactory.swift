//
//  CBFlashyTabButtonFactory.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 20/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

public struct CBFlashyTabBarConfig {
    let deselectedOpacity: CGFloat

    public init(deselectedOpacity: CGFloat) {
        self.deselectedOpacity = max(0.0, min(1.0, deselectedOpacity))
    }
}

class CBFlashyTabButtonFactory: CBTabButtonFactory {

    let config: CBFlashyTabBarConfig?

    init(config: CBFlashyTabBarConfig? = nil) {
        self.config = config
    }

    private var animationSpeed: Double = 1.0
    
    func buttons(forItems items: [UITabBarItem]) -> [CBTabBarButton] {
        return items.map { item -> CBTabBarButton in
            let button = CBFlashyTabBarButton(item: item)
            button.config = config
            button.selectAnimation = CBFlashyTabItemSelectAnimation(duration: 0.3 / animationSpeed)
            button.deselectAnimation = CBFlashyTabItemDeselectAnimation(duration: 0.3 / animationSpeed)
            return button
        }
    }
    
}
