//
//  CGPoint.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 22/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

extension CGPoint {
    func offsetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}
