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
        
        if isPresenting {
            let toController = transitionContext.viewController(forKey: .to) as! GroupDetailsViewController
            let fromTabBarController = transitionContext.viewController(forKey: .from) as! UITabBarController
            let fromController = fromTabBarController.selectedViewController! as! ViewController
            
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            toController.groupContainerView.alpha = 0
            containerView.backgroundColor = fromController.view.backgroundColor
            
//            toController.contentContainer.alpha = 0
//            toController.contentContainer.transform = CGAffineTransform(translationX: 0, y: -150)
            
            let ip = toController.indexPath
            let targetCell = fromController.transitionCollectionView.cellForItem(at: ip)!
            let snapshot = targetCell.snapshotView(afterScreenUpdates: false)!
            snapshot.apply(.shadowed)
            let snapshotOrigin = fromController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            snapshot.frame = CGRect(origin: snapshotOrigin, size: targetCell.frame.size)

            containerView.addSubview(fromTabBarController.view)
            containerView.addSubview(toController.view)
            toController.view.alpha = 0
            containerView.addSubview(snapshot)
            
            targetCell.alpha = 0
            let toOrigin = toController.groupContainerView.superview!.convert(toController.groupContainerView.frame.origin, to: containerView)
            
            let anim = CABasicAnimation(keyPath: "transform.translation.y")
            anim.fromValue = -50
            anim.toValue = 0
            anim.duration = duration
//            anim.speed = 0.8
            anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            let reveal = CABasicAnimation(keyPath: "opacity")
            reveal.fromValue = 0.0
            reveal.toValue = 1.0
            reveal.duration = duration
//            reveal.speed = 1
            toController.contentContainer.layer.add(anim, forKey: nil)
            toController.contentContainer.layer.add(reveal, forKey: nil)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                snapshot.frame.origin.y = toOrigin.y

//                fromTabBarController.view.alpha = 0
                
                toController.view.alpha = 1
                toController.contentContainer.alpha = 1
                toController.contentContainer.transform = CGAffineTransform.identity
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
            let toController = toTabBarController.selectedViewController! as! ViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupDetailsViewController
            containerView.addSubview(fromController.view)
            containerView.addSubview(toTabBarController.view)
            toTabBarController.view.frame = transitionContext.finalFrame(for: toTabBarController)
            
            let targetCell = toController.groupsCollectionView.cellForItem(at: fromController.indexPath)!
            let snapshot = fromController.groupContainerView.snapshotView(afterScreenUpdates: false)!
            snapshot.apply(.shadowed)
            let snapshotOriginTo = toController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            let snapshotOriginFrom = fromController.groupContainerView.superview!.convert(fromController.groupContainerView.frame.origin, to: containerView)
            snapshot.frame.origin = snapshotOriginFrom
            containerView.addSubview(snapshot)
            fromController.groupContainerView.alpha = 0
            
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
//                fromController.view.alpha = 0
                toTabBarController.view.alpha = 1
                toController.view.alpha = 1
                fromController.contentContainer.transform = CGAffineTransform(translationX: 0, y: -50)
                snapshot.frame.origin = snapshotOriginTo
            }) { finished in
                targetCell.alpha = 1
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    
}
