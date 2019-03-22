//
//  GroupDetailsNavigationTransition.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 20/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            let toController = transitionContext.viewController(forKey: .to) as! GroupNavigationDetailsViewController
//            let fromTabBarController = transitionContext.viewController(forKey: .from) as! UITabBarController
            let fromController = transitionContext.viewController(forKey: .from) as! ViewController
            
            let headerHeight = (toController.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
//            toController.groupContainer.alpha = 0
            containerView.backgroundColor = fromController.view.backgroundColor
            
            toController.view.backgroundColor = .clear
//            toController.contentContainer.alpha = 0
            
            
            let ip = toController.indexPath
            let targetCell = fromController.transitionCollectionView.cellForItem(at: ip)!
//            let snapshot = targetCell.snapshotView(afterScreenUpdates: false)!
//            snapshot.apply(.shadowed)
            let snapshotOrigin = fromController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            toController.titleToTopConstraint.constant = snapshotOrigin.y
            let groupOffset = (toController.view.frame.width - targetCell.frame.width) / 2
            toController.groupLeftConstraint.constant = groupOffset
            toController.groupRightConstraint.constant = groupOffset
            toController.view.layoutIfNeeded()
            
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
//            toController.view.alpha = 0
//            containerView.addSubview(snapshot)
            
            targetCell.alpha = 0
//            let toOrigin = toController.groupContainerView.superview!.convert(toController.groupContainerView.frame.origin, to: containerView)
            
            let titleLabelLeft = (toController.view.frame.width - toController.titleLabel.frame.width) / 2
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                
//                snapshot.frame.origin.y = toOrigin.y
                toController.titleToTopConstraint.constant = 0
                toController.groupLeftConstraint.constant = 0
                toController.groupRightConstraint.constant = 0
                toController.titleLeftConstraint.constant = titleLabelLeft
                toController.headerHeightConstraint.constant = headerHeight
                toController.view.layoutIfNeeded()
                fromController.view.alpha = 0
                
//                toController.view.alpha = 1
//                toController.contentContainer.alpha = 1
//                toController.contentContainer.transform = CGAffineTransform.identity

            }) { _ in

//                toController.groupContainerView.alpha = 1
//                snapshot.removeFromSuperview()
                toController.navigationController?.isNavigationBarHidden = false
                toController.titleToTopConstraint.constant = -headerHeight
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
            
        else {
            let toController = transitionContext.viewController(forKey: .to) as! ViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupNavigationDetailsViewController
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
            toController.view.frame = transitionContext.finalFrame(for: toController)
            
            let targetCell = toController.groupsCollectionView.cellForItem(at: fromController.indexPath)!
//            let snapshot = fromController.groupContainerView.snapshotView(afterScreenUpdates: false)!
//            snapshot.apply(.shadowed)
            let snapshotOriginTo = toController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
//            let snapshotOriginFrom = fromController.groupContainerView.superview!.convert(fromController.groupContainerView.frame.origin, to: containerView)
//            snapshot.frame.origin = snapshotOriginFrom
//            containerView.addSubview(snapshot)
//            fromController.groupContainerView.alpha = 0
            
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                //                fromController.view.alpha = 0
                toController.view.alpha = 1
                
                fromController.titleToTopConstraint.constant = snapshotOriginTo.y
                fromController.view.layoutIfNeeded()

//                snapshot.frame.origin = snapshotOriginTo
            }) { finished in
                targetCell.alpha = 1
//                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
}
