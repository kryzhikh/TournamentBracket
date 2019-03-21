//
//  GroupDetailsNavigationTransition.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 20/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsNavigationTransition: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case presenting, dismissing
    }
    
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
            let fromController = transitionContext.viewController(forKey: .from) as! ViewController
            toController.view.frame = transitionContext.finalFrame(for: toController)
//            toController.groupContainer.alpha = 0
            //            toController.contentContainer.alpha = 0
            //            toController.contentContainer.transform = CGAffineTransform(translationX: 0, y: -150)
            let targetCell = fromController.transitionCollectionView.cellForItem(at: toController.indexPath)!
//            let snapshot = targetCell.snapshotView(afterScreenUpdates: false)!
            let cellOrigin = fromController.groupsCollectionView.convert(targetCell.frame.origin, to: nil)
//            snapshot.frame = CGRect(origin: snapshotOrigin, size: targetCell.frame.size)
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
//            containerView.addSubview(snapshot)
            
            toController.titleToTopConstraint.constant = cellOrigin.y
            
            targetCell.alpha = 0
            let toOrigin = toController.groupContainer.superview!.convert(toController.groupContainer.frame.origin, to: containerView)
            
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                fromController.view.alpha = 0
                toController.titleToTopConstraint.constant = 1
                toController.view.layoutIfNeeded()
            }) { _ in
//                fromController.groupsCollectionView.visibleCells.forEach({ cell in
//                    cell.transform = CGAffineTransform.identity
//                })
//                toController.groupContainer.alpha = 1
//                snapshot.removeFromSuperview()
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
            let snapshot = fromController.groupContainer.snapshotView(afterScreenUpdates: false)!
            let snapshotOriginTo = toController.groupsCollectionView.convert(targetCell.frame.origin, to: containerView)
            let snapshotOriginFrom = fromController.groupContainer.superview!.convert(fromController.groupContainer.frame.origin, to: containerView)
            snapshot.frame.origin = snapshotOriginFrom
            containerView.addSubview(snapshot)
            fromController.groupContainer.alpha = 0
            
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                //                fromController.view.alpha = 0
                toController.view.alpha = 1
//                fromController.contentContainer.transform = CGAffineTransform(translationX: 0, y: -50)
                snapshot.frame.origin = snapshotOriginTo
            }) { finished in
                targetCell.alpha = 1
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
}
