//
//  CBMenuPresenter.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 21/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBMenuPresenter: NSObject {
    
    private let menu: CBTabMenu
    
    init(menu: CBTabMenu) {
        self.menu = menu
    }
    
    weak var presentationController: UIViewController?
    weak var menuButton: CBMenuButton? {
        didSet {
            guard let button = menuButton else { return }
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(menuBtnPan))
            button.addGestureRecognizer(panGesture)
            button.addTarget(self, action: #selector(menuBtnPressed), for: .touchUpInside)
        }
    }
    
    var presentAnimationController: CBMenuPresentAnimationController?
    var presentInteractionController: CBMenuPresentAnimationController?
    var dismissAnimationController: CBMenuDismissAnimationController?
    
    @objc func menuBtnPressed() {
        guard let menuController = createMenuController() else {
            return
        }
        configureAnimationControllers()
        presentInteractionController = nil
        menuController.loadViewIfNeeded()
        menuController.transitioningDelegate = self
        presentationController?.present(menuController, animated: true, completion: nil)
    }
    
    private func configureAnimationControllers() {
        presentAnimationController = CBMenuPresentAnimationController()
        presentAnimationController?.menuButton = menuButton
        presentAnimationController?.maxOffset = maxOffset
        dismissAnimationController = CBMenuDismissAnimationController()
        dismissAnimationController?.menuButton = menuButton
    }
    
    @objc func menuBtnPan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            didBeganPan(withGesture: sender)
        case .changed:
            didChangePan(withGesture: sender)
        default:
            didEndPan(withGesture: sender)
        }
    }
    
    private func createMenuController() -> UIViewController? {
        let storyboard = UIStoryboard(name: "CBMenuController", bundle: Bundle.resourseBundle)
        let controller = storyboard.instantiateInitialViewController() as? CBMenuController
        controller?.menu = menu
        controller?.modalPresentationStyle = .fullScreen
        return controller
    }
    
    private var maxOffset: CGFloat = 180
    private var startY: CGFloat?
    private var lastProgress: CGFloat?
    private func didBeganPan(withGesture gesture: UIPanGestureRecognizer) {
        guard let container = gesture.view?.superview else {
            return
        }
        startY = gesture.location(in: container).y
        
        guard let menuController = createMenuController() else {
            return
        }
        configureAnimationControllers()
        presentInteractionController = presentAnimationController
        menuController.loadViewIfNeeded()
        menuController.transitioningDelegate = self
        presentationController?.present(menuController, animated: true, completion: nil)
    }

    private func didChangePan(withGesture gesture: UIPanGestureRecognizer) {
        guard let container = gesture.view?.superview else {
            return
        }
        let currentY = gesture.location(in: container).y
        let diff = max(0, (startY ?? 0) - currentY)
        let progress = min(1.0, diff / (maxOffset * 2))
        lastProgress = progress
        if diff >= maxOffset {
            gesture.isEnabled = false
            presentAnimationController?.finishTransition()
            gesture.isEnabled = true
            return
        }
        presentAnimationController?.update(to: progress, offset: diff)
    }
    
    private func didEndPan(withGesture gesture: UIPanGestureRecognizer) {
        defer {
            startY = nil
            lastProgress = nil
        }
        guard let lastProgress = lastProgress else {
            return
        }
        if lastProgress > 0.4 {
            presentAnimationController?.finishTransition()
        } else {
            presentAnimationController?.cancelTransition()
        }
    }
}

extension CBMenuPresenter: UIViewControllerTransitioningDelegate {
        
        func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return presentAnimationController
        }
        
        func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
            return dismissAnimationController
        }
    
    
        func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return presentInteractionController
        }
    
        func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
            return nil
        }
}


