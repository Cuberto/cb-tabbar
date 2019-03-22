//
//  CBFadeTabButtonFactory.swift
//  CBFlashyTabBarController
//
//  Created by Anton Skopin on 22/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBFadeTabButtonFactory: CBTabButtonFactory {
    
    func buttons(forItems items: [UITabBarItem]) -> [CBTabBarButton] {
        return items.map { CBFadeTabBarButton(item: $0) }
    }
    
}
