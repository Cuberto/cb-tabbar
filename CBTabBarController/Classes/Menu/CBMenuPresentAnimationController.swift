//
//  CBMenuPresentAnimationController.swift
//  CBTabBarController
//
//  Created by Anton Skopin on 21/03/2019.
//  Copyright © 2019 cuberto. All rights reserved.
//

import UIKit

class CBMenuPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerInteractiveTransitioning {

    var maxOffset: CGFloat = 0
    let offsetSpeed: CGFloat = 650
    private let duration: Double = 0.5
    private var interactiveContext: UIViewControllerContextTransitioning?
    private var transitionContext: UIViewControllerContextTransitioning?
    private var fromView: UIView?
    private var toView: UIView?
    private var toViewController: CBMenuController?
    private var displayLink: CADisplayLink?
    private var lastProgress: CGFloat?
    private var lastOffset: CGFloat = 0
    private var startTime: TimeInterval = CACurrentMediaTime()
    weak var menuButton: UIView?
    private var animationButton: UIView?
    private var animationButtonStart: CGRect = .zero
    deinit {
        clear()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(maxOffset/offsetSpeed)
    }
    
    private func startTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from) else { return }
        guard let toView = transitionContext.view(forKey: .to) else { return }
        toViewController = transitionContext.viewController(forKey: .to) as? CBMenuController
        self.fromView = fromView
        self.toView = toView
        self.transitionContext = transitionContext
        let mask = CAShapeLayer()
    
        let container = transitionContext.containerView
        container.addSubview(toView)
        if let menuButton = menuButton,
            let animationButton = menuButton.snapshotView(afterScreenUpdates: false) {
            container.addSubview(animationButton)
            animationButton.frame = fromView.convert(menuButton.frame, from: menuButton.superview)
            animationButtonStart = animationButton.frame
            self.animationButton = animationButton
        }
        toViewController?.menuContainer.alpha = 0
        toViewController?.dismissButton.alpha = 0
        menuButton?.isHidden = true
        toView.layer.mask = mask

        startTime = CACurrentMediaTime()
        lastOffset = 0
        let displayLink = CADisplayLink(target: self, selector: #selector(screenUpdate))
        displayLink.add(to: .current, forMode: .common)
        self.displayLink = displayLink
        
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        startTransition(using: transitionContext)
    }
    
    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        interactiveContext = transitionContext
        startTransition(using: transitionContext)
    }
    
    func update(to progress: CGFloat, offset: CGFloat) {
        lastProgress = progress
        lastOffset = offset
    }
    
    var finishing: Bool = false
    var cancelling: Bool = false
    var lastScreenUpdateTime: TimeInterval = CACurrentMediaTime()
    
    @objc func screenUpdate() {
        defer {
            lastScreenUpdateTime = CACurrentMediaTime()
        }
        
        let progress = lastProgress ?? CGFloat((CACurrentMediaTime() - startTime)/duration)
        let timeDiff = CGFloat(CACurrentMediaTime() - lastScreenUpdateTime)
        var alphaProgress = min(1.0, progress/0.3)
        
        if cancelling || finishing {
            lastOffset -= offsetSpeed * timeDiff
            lastOffset = max(minOffset, lastOffset)
        } else if lastProgress == nil {
            lastOffset += offsetSpeed * timeDiff
            finishing = lastOffset > maxOffset
            finishOffset = -lastOffset
        }
        
        var btnOffset = -lastOffset
        var buttonOnPlace: Bool = false
        var buttonAnimationFinished: Bool = false
        let maskOnPlace: Bool = (lastOffset <= minOffset)
        let menuTargetOffsetY = (toViewController?.dismissButton.frame.minY ?? 0) - animationButtonStart.minY
        
        if finishing {
            let btnOffsetSpeed = offsetSpeed * (abs(menuTargetOffsetY)/(maxOffset + 100))
            finishOffset -= btnOffsetSpeed * timeDiff
            buttonOnPlace = finishOffset <= menuTargetOffsetY
            btnOffset = max(menuTargetOffsetY, finishOffset)
            let finishPercent = (maxOffset + finishOffset)/(menuTargetOffsetY + maxOffset)
            toViewController?.menuContainer.alpha = min(1.0, finishPercent)
            if buttonOnPlace && !buttonAnimationFinished {
                let btnAlphaSpeed: CGFloat = 4
                if let btnDismiss = toViewController?.dismissButton {
                    btnDismiss.alpha = min(1.0, btnDismiss.alpha + btnAlphaSpeed * timeDiff)
                }
                if let btnPresent = animationButton {
                    btnPresent.alpha = max(0.0, btnPresent.alpha - btnAlphaSpeed * timeDiff)
                    buttonAnimationFinished = btnPresent.alpha <= 0
                } else {
                    buttonAnimationFinished = true
                }
            }
        }
        
        if cancelling {
            alphaProgress = min(alphaProgress, (lastOffset - minOffset)/(cancelOffset - minOffset))
        }
        
        if let toView = toView {
            toView.alpha = alphaProgress
            if finishing {
                (toView.layer.mask as? CAShapeLayer)?.path = finishPath(forView: toView,
                                                                  offset: lastOffset)
            } else {
                (toView.layer.mask as? CAShapeLayer)?.path = path(forView: toView,
                                                                  offset: lastOffset)
            }
            
        }
        if let animationButton = animationButton {
            animationButton.transform = CGAffineTransform(translationX: 0, y: min(0, btnOffset))
                                            .rotated(by: btnOffset/menuTargetOffsetY * CGFloat.pi/4.0)
        }
        
        if finishing && buttonOnPlace && maskOnPlace && buttonAnimationFinished {
            transitionContext?.completeTransition(true)
            menuButton?.isHidden = false
            toViewController?.menuContainer.alpha = 1.0
            toViewController?.dismissButton.alpha = 1.0
            clear()
            return
        }
        if cancelling && maskOnPlace {
            toView?.removeFromSuperview()
            menuButton?.isHidden = false
            transitionContext?.completeTransition(false)
            clear()
            return
        }
    }
    
    var minOffset: CGFloat {
        return 0
    }
    
    func lineCoeff(pt1: CGPoint, pt2: CGPoint) -> (k: CGFloat, b: CGFloat) {
        if pt1.x == pt2.y {
            return (k: 0, b: 0)
        }
        let k = (pt1.y - pt2.y)/(pt1.x - pt2.x)
        let b = pt1.y - k * pt1.x
        return (k: k, b: b)
    }
    
    private let defaultCentralOffsetY: CGFloat = 60
    func path(forView view: UIView, offset: CGFloat) -> CGPath {
        let centerX = menuButton?.frame.midX ?? view.bounds.width/2
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        let bottomOffset: CGFloat = 0
        let pt1 = CGPoint(x: centerX + view.bounds.width/2, y: view.bounds.height + bottomOffset)
        path.addLine(to: pt1)
        let centralOffsetX = max(28.0, 50 - abs(offset * 0.2))
        let centralOffsetY =  60 / 375 * view.bounds.width + offset * (0.83 / 320 * view.bounds.width)
        let pt2 = CGPoint(x: centerX + centralOffsetX, y: view.bounds.height - centralOffsetY)
        let pt3 = CGPoint(x: centerX - centralOffsetX, y: view.bounds.height - centralOffsetY)
        let pt4 = CGPoint(x: centerX - view.bounds.width/2, y: view.bounds.height + bottomOffset)
        let dcp21x: CGFloat = 55 / 375 * view.bounds.width
        let cpt21 = pt2.offsetBy(dx: max(-(centralOffsetX + 10), dcp21x - offset * 0.6),
                                 dy: 50 + max(0, offset * 0.5))
        
        let rightLineCoeff = lineCoeff(pt1: cpt21, pt2: pt2)
        let cpt22y: CGFloat = pt2.y - max(10.0, dcp21x - max(0, offset * 0.1))
        let cpt22x: CGFloat = rightLineCoeff.k != 0 ? (cpt22y - rightLineCoeff.b)/rightLineCoeff.k : 0
        let cpt22 = CGPoint(x: cpt22x, y: cpt22y)
        let cpt31 = CGPoint(x: pt3.x + (pt2.x - cpt22.x), y: cpt22y)
        let cpt32 = CGPoint(x: pt3.x - (cpt21.x - pt2.x), y: cpt21.y)
        
        let dcpt12x = -44 / 375 * view.bounds.width - max(0, offset * 0.5)
        
        path.addCurve(to: pt2,
                      controlPoint1: pt1.offsetBy(dx: dcpt12x, dy: 0),
                      controlPoint2: cpt21)
        path.addCurve(to: pt3,
                      controlPoint1: cpt22,
                      controlPoint2: cpt31)
        path.addCurve(to: pt4,
                      controlPoint1: cpt32,
                      controlPoint2: pt4.offsetBy(dx: -dcpt12x, dy: 0))
        path.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        path.close()
        return path.cgPath
    }
    
    func finishPath(forView view: UIView, offset: CGFloat) -> CGPath {
        let centerX = menuButton?.frame.midX ?? view.bounds.width/2
        let correctedOffset = offset - 50
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: view.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: view.bounds.width, y: view.bounds.height))
        let bottomOffset: CGFloat = 0
        let pt1 = CGPoint(x: centerX + view.bounds.width/2, y: view.bounds.height + bottomOffset)
        path.addLine(to: pt1)
        let centralOffsetX: CGFloat = 10
        let centralOffsetY =  correctedOffset * 0.9
        let pt2 = CGPoint(x: centerX + centralOffsetX, y: view.bounds.height - centralOffsetY)
        let pt3 = CGPoint(x: centerX - centralOffsetX, y: view.bounds.height - centralOffsetY)
        let pt4 = CGPoint(x: centerX - view.bounds.width/2, y: view.bounds.height + bottomOffset)
        let dcp21x: CGFloat = 10 / 375 * view.bounds.width
        let dcp21xCorrected: CGFloat = dcp21x
        let cpt21 = pt2.offsetBy(dx: dcp21xCorrected,
                                 dy: min(view.bounds.height - pt2.y, 50 + max(0, correctedOffset * 0.5)))
        
        let rightLineCoeff = lineCoeff(pt1: cpt21, pt2: pt2)
        let cpt22y: CGFloat = pt2.y - min(cpt21.y - pt2.y,
                                          max(10.0, dcp21x - max(0, correctedOffset * 0.1)))
        let cpt22x: CGFloat = rightLineCoeff.k != 0 ? (cpt22y - rightLineCoeff.b)/rightLineCoeff.k : 0
        let cpt22 = CGPoint(x: cpt22x, y: cpt22y)
        let cpt31 = CGPoint(x: pt3.x + (pt2.x - cpt22.x), y: cpt22y)
        let cpt32 = CGPoint(x: pt3.x - (cpt21.x - pt2.x), y: cpt21.y)
        
        let dcpt12x = -44 / 375 * view.bounds.width - max(0, correctedOffset * 0.5)
        
        path.addCurve(to: pt2,
                      controlPoint1: pt1.offsetBy(dx: dcpt12x, dy: 0),
                      controlPoint2: cpt21)
        path.addCurve(to: pt3,
                      controlPoint1: cpt22,
                      controlPoint2: cpt31)
        path.addCurve(to: pt4,
                      controlPoint1: cpt32,
                      controlPoint2: pt4.offsetBy(dx: -dcpt12x, dy: 0))
        path.addLine(to: CGPoint(x: 0, y: view.bounds.height))
        path.close()
        return path.cgPath
    }
    
    var cancelOffset: CGFloat = 0
    var finishOffset: CGFloat = 0
    
    func finishTransition() {
        finishOffset = -lastOffset
        interactiveContext?.finishInteractiveTransition()
        finishing = true
    }
    
    func cancelTransition() {
        cancelOffset = lastOffset
        interactiveContext?.cancelInteractiveTransition()
        cancelling = true
    }
    
    func clear() {
        toView?.layer.mask = nil
        fromView = nil
        toView = nil
        interactiveContext = nil
        displayLink?.remove(from: .current, forMode: .common)
        displayLink = nil
        cancelling = false
        cancelling = false
        menuButton = nil
        animationButton?.removeFromSuperview()
        animationButton = nil
    }
}
