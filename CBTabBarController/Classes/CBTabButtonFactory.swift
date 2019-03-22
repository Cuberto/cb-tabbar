//
//  CBTabBarStyle.swift
//  CBFlashyTabBarController
//
//  Created by Anton Skopin on 19/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

typealias CBTabBarButton = UIControl & CBTabBarButtonProtocol

protocol CBTabBarButtonProtocol {
    init(item: UITabBarItem)
    var item: UITabBarItem? { get set }
    func setSelected(_ selected: Bool, animated: Bool)
    var requiredSize: CGSize? { get }
}


extension CBTabBarButtonProtocol {
    var requiredSize: CGSize? {
        return nil
    }
}

protocol CBTabButtonFactory {
    func buttons(forItems item: [UITabBarItem]) -> [CBTabBarButton]
}
