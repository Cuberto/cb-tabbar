//
//  CBTabItemBasicAnimation.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 28/11/2018.
//  Copyright © 2018 cuberto. All rights reserved.
//

import UIKit

protocol CBFlashyTabItemBasicAnimation: CBTabItemAnimation {

    func imageOffsetAnimation(forTabBarItem item: CBFlashyTabBarButton) -> CAAnimation
    func imageMaskAnimation(forTabBarItem item: CBFlashyTabBarButton) -> CAAnimation
    func labelOffsetAnimation(forTabBarItem item: CBFlashyTabBarButton) -> CAAnimation
    func labelMaskAnimation(forTabBarItem item: CBFlashyTabBarButton) -> CAAnimation
    func dotScaleAnimation(forTabBarItem item: CBFlashyTabBarButton) -> CAAnimation

    var duration: Double { get }

}

extension CBFlashyTabItemBasicAnimation {

    func playAnimation(forTabBarItem item: CBTabBarButton, completion: (() -> Void)? = nil) {
        guard let item = item as? CBFlashyTabBarButton else {
            fatalError("This animation can be used only with CBFlashyTabBarButton")
        }
        let animateImageOffset = imageOffsetAnimation(forTabBarItem: item)
        let animateImageMask = imageMaskAnimation(forTabBarItem: item)
        animateImageMask.isRemovedOnCompletion = false

        let animateLabelOffset = labelOffsetAnimation(forTabBarItem: item)
        let animateLabelMask = labelMaskAnimation(forTabBarItem: item)
        animateLabelMask.isRemovedOnCompletion = false

        let dotAnimation = dotScaleAnimation(forTabBarItem: item)

        let mainAnimations: [CAAnimation] = [animateImageOffset,
                                             animateImageMask,
                                             animateLabelOffset,
                                             animateLabelMask,
                                             dotAnimation]
        mainAnimations.forEach { (animation) in
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = .forwards
        }
        if item.tabImage.layer.mask == nil {
            let imageMask = CAShapeLayer()
            imageMask.frame = item.tabImage.bounds
            item.tabImage.layer.mask = imageMask
        }

        if let animateImageMask = animateImageMask as? CAKeyframeAnimation,
           let imageMask = item.tabImage.layer.mask as? CAShapeLayer {
            imageMask.path = (animateImageMask.values as? [CGPath])?.last
        }

        if item.tabLabel.layer.mask == nil {
            let labelMask = CAShapeLayer()
            labelMask.frame = item.tabLabel.bounds
            item.tabLabel.layer.mask = labelMask
        }

        if let animateLabelMask = animateLabelMask as? CAKeyframeAnimation,
           let labelMask = item.tabLabel.layer.mask as? CAShapeLayer {
            labelMask.path = (animateLabelMask.values as? [CGPath])?.last
        }

        let timing = CAMediaTimingFunction(name: .easeOut)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timing)
        CATransaction.setCompletionBlock { completion?() }
        item.tabImage.layer.add(animateImageOffset, forKey: "offset")
        item.tabLabel.layer.add(animateLabelOffset, forKey: "offset")
        item.dotView.layer.add(dotAnimation, forKey: "scale")
        item.tabImage.layer.mask?.add(animateImageMask, forKey: "path")
        item.tabLabel.layer.mask?.add(animateLabelMask, forKey: "path")
        CATransaction.commit()
    }

}
