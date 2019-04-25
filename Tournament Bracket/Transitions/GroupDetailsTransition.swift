//
//  GroupDetailsTransition.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 15/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var duration: TimeInterval
    var isPresenting: Bool
    
    weak var context: UIViewControllerContextTransitioning?
    
    init(duration: TimeInterval, isPresenting: Bool) {
        self.duration = duration
        self.isPresenting = isPresenting
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        context = transitionContext
        if isPresenting {
            let toController = transitionContext.viewController(forKey: .to) as! GroupDetailsViewController
            let fromTabBarController = transitionContext.viewController(forKey: .from) as! UITabBarController
            let fromController = fromTabBarController.selectedViewController! as! TournamentsViewController
            
            containerView.backgroundColor = fromController.view.backgroundColor
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            toController.groupContainerView.alpha = 0
            toController.view.alpha = 0
            
            let targetCell = fromController.transitionCollectionView.cellForItem(at: toController.indexPath)!
            targetCell.alpha = 0
            let snapshot = targetCell.snapshotView(afterScreenUpdates: false)!
            snapshot.apply(.shadowed)
            let snapshotInitialOrigin = fromController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            snapshot.frame = CGRect(origin: snapshotInitialOrigin, size: targetCell.frame.size)

            containerView.addSubview(fromTabBarController.view)
            containerView.addSubview(toController.view)
            containerView.addSubview(snapshot)
            
            let snapshotFinalOrigin = toController.groupContainerView.superview!.convert(toController.groupContainerView.frame.origin, to: containerView)
            
            let anim = CABasicAnimation(keyPath: "transform.translation.y")
            anim.fromValue = -50
            anim.toValue = 0
            anim.duration = duration
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            let reveal = CABasicAnimation(keyPath: "opacity")
            reveal.fromValue = 0.0
            reveal.toValue = 1.0
            reveal.duration = duration
            toController.contentContainer.layer.add(anim, forKey: nil)
            toController.contentContainer.layer.add(reveal, forKey: nil)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                snapshot.frame.origin.y = snapshotFinalOrigin.y
                toController.view.alpha = 1

                // animate other cells out
                fromController.groupsCollectionView.visibleCells.forEach({ cell in
                    let tY: CGFloat = cell.frame.minY < targetCell.frame.minY ? -100 : 100
                    cell.transform = CGAffineTransform(translationX: 0, y: tY)
                })
            }) { _ in
                fromController.groupsCollectionView.visibleCells.forEach({ cell in
                    cell.transform = CGAffineTransform.identity
                })
                toController.groupContainerView.alpha = 1
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
        else {
            let toTabBarController = transitionContext.viewController(forKey: .to) as! UITabBarController
            let toController = toTabBarController.selectedViewController! as! TournamentsViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupDetailsViewController
            
            fromController.groupContainerView.alpha = 0
            toController.view.alpha = 0
            toTabBarController.view.frame = transitionContext.finalFrame(for: toTabBarController)
            
            let targetCell = toController.groupsCollectionView.cellForItem(at: fromController.indexPath)!
            let snapshot = fromController.groupContainerView.snapshotView(afterScreenUpdates: false)!
            snapshot.apply(.shadowed)
            let snapshotFinalOrigin = toController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            let snapshotInitialOrigin = fromController.groupContainerView.superview!.convert(fromController.groupContainerView.frame.origin, to: containerView)
            snapshot.frame.origin = snapshotInitialOrigin
            
            containerView.addSubview(fromController.view)
            containerView.addSubview(toTabBarController.view)
            containerView.addSubview(snapshot)

            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                toTabBarController.view.alpha = 1
                toController.view.alpha = 1
                fromController.contentContainer.transform = CGAffineTransform(translationX: 0, y: -50)
                snapshot.frame.origin = snapshotFinalOrigin
            }) { finished in
                snapshot.removeFromSuperview()
                if transitionContext.transitionWasCancelled {
                    fromController.groupContainerView.alpha = 1
                    containerView.insertSubview(fromController.view, aboveSubview: toController.view)
                }
                else {
                    targetCell.alpha = 1
                }
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    
}
