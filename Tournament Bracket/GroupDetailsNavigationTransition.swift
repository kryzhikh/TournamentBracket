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
            let fromController = transitionContext.viewController(forKey: .from) as! UIViewController & CollectionTransitionable
            
            containerView.backgroundColor = fromController.view.backgroundColor
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            toController.view.backgroundColor = .clear
            
            let targetCell = fromController.transitionCollectionView.cellForItem(at: toController.indexPath)!
            targetCell.alpha = 0
            
            let cellOrigin = fromController.transitionCollectionView.convert(targetCell.frame.origin, to: containerView)
            toController.titleToTopConstraint.constant = cellOrigin.y
            toController.groupContainerWidthConstraint.constant = targetCell.frame.width
            toController.view.layoutIfNeeded()
            
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
            
            let headerHeight = (toController.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
            let titleLabelLeft = (toController.view.frame.width - toController.titleLabel.frame.width) / 2
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                
                toController.titleToTopConstraint.constant = 0
                toController.groupContainerWidthConstraint.constant = toController.view.frame.width
                toController.titleLeftConstraint.constant = titleLabelLeft
                toController.headerHeightConstraint.constant = headerHeight
                toController.view.layoutIfNeeded()
                fromController.view.alpha = 0
            }) { _ in
                toController.navigationController?.isNavigationBarHidden = false
                toController.titleToTopConstraint.constant = -headerHeight
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
            
        }
            
        else { //dismissing
            let toController = transitionContext.viewController(forKey: .to) as! GroupsViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupNavigationDetailsViewController
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            
            let targetCell = toController.groupsCollectionView.cellForItem(at: fromController.indexPath)!
            targetCell.alpha = 0
            let snapshotOriginTo = toController.groupsCollectionView.convert(targetCell.frame.origin, to: fromController.view)
            
            containerView.addSubview(toController.view)
            containerView.addSubview(fromController.view)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                toController.view.alpha = 1
                fromController.view.backgroundColor = .clear
                
                fromController.groupContainer.apply(.rounded)
                fromController.groupContainer.apply(.shadowed)
                fromController.groupContentView.apply(.rounded)
                
                fromController.groupContainerWidthConstraint.constant = targetCell.frame.width
                fromController.titleToTopConstraint.constant = snapshotOriginTo.y
                fromController.titleLeftConstraint.constant = 20
                fromController.headerHeightConstraint.constant = 44
                fromController.view.layoutIfNeeded()

            }) { finished in
                targetCell.alpha = 1
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
    }
    
    func presentTransition() {
        
    }
    
}
