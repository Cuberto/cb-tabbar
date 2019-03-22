//
//  CBMenuDismissAnimationController.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 22/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//
import UIKit


class CBMenuDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: Double = 0.25
    weak var menuButton: UIView?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to) else { return }
        
        let fromViewController = transitionContext.viewController(forKey: .from) as? CBMenuController
        let container = transitionContext.containerView
        let animationDismissButton = fromViewController?.dismissButton?.snapshotView(afterScreenUpdates: false)
        let animationPresentButton = menuButton?.snapshotView(afterScreenUpdates: true)
        var targetFrame: CGRect?
        
        container.insertSubview(toView, at: 0)
        if let menuButton = menuButton,
            let presentButton = animationPresentButton,
            let dismissButton = animationDismissButton,
            let sourceFrame = fromViewController?.dismissButton?.frame {
            
            targetFrame = fromView.convert(menuButton.frame, from: menuButton.superview)
            container.addSubview(presentButton)
            container.addSubview(dismissButton)
            fromViewController?.dismissButton?.isHidden = true
            presentButton.frame = sourceFrame
            dismissButton.frame = sourceFrame
        }
        menuButton?.isHidden = true
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            fromView.alpha = 0
            if let targetFrame = targetFrame {
                animationPresentButton?.frame = targetFrame
                animationDismissButton?.frame = targetFrame
                animationDismissButton?.alpha = 0
            }
        }) { (_) in
            self.menuButton?.isHidden = false
            animationPresentButton?.removeFromSuperview()
            animationDismissButton?.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let completion: () -> Void = anim.value(forKey: "completion") as? (() -> Void) {
            completion()
        }
    }
    
}
