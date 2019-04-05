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
            let toController = transitionContext.viewController(forKey: .to) as! GroupNavigationDetailsViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupsViewController
            
            containerView.backgroundColor = fromController.view.backgroundColor
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            toController.view.backgroundColor = .clear
            
            let targetCell = fromController.transitionCollectionView.cellForItem(at: toController.indexPath)!
            targetCell.alpha = 0
            
            let groupStartOrigin = fromController.transitionCollectionView.convert(targetCell.frame.origin, to: containerView)
            toController.groupToTopConstraint.constant = groupStartOrigin.y
            toController.groupContainerWidthConstraint.constant = targetCell.frame.width
            toController.view.layoutIfNeeded()
            
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
            
            let headerHeight = (toController.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
            
            let start = Date()
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                fromController.view.alpha = 0
                
                toController.groupToTopConstraint.constant = 0
                toController.groupContainerWidthConstraint.constant = toController.view.frame.width
                toController.groupView.titlePosition = .center
                toController.groupView.headerHeight = headerHeight
                toController.view.layoutIfNeeded()
            }) { _ in
                print("Animation duration: ", Date().timeIntervalSince(start))
                toController.navigationController?.isNavigationBarHidden = false
                toController.groupToTopConstraint.constant = -headerHeight
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }
            
        else { //dismissing
            let toController = transitionContext.viewController(forKey: .to) as! GroupsViewController
            let fromController = transitionContext.viewController(forKey: .from) as! GroupNavigationDetailsViewController
            
            toController.view.frame = transitionContext.finalFrame(for: toController)
            
            let targetCell = toController.groupsCollectionView.cellForItem(at: fromController.indexPath)!
            targetCell.alpha = 0
            let groupFinalOrigin = toController.groupsCollectionView.convert(targetCell.frame.origin, to: fromController.view)
            
            let headerHeight = (toController.navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.height
            
            containerView.addSubview(toController.view)
            containerView.addSubview(fromController.view)
            
            UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                toController.view.alpha = 1
                fromController.view.backgroundColor = .clear
                
                fromController.groupContainer.apply(.rounded)
                fromController.groupContainer.apply(.shadowed)
                fromController.groupContentView.apply(.rounded)
                
                fromController.groupContainerWidthConstraint.constant = targetCell.frame.width
                fromController.groupToTopConstraint.constant = groupFinalOrigin.y
                fromController.groupView.titlePosition = .left
                fromController.groupView.headerHeight = fromController.groupView.titleHeight
                fromController.view.layoutIfNeeded()

            }) { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                if transitionContext.transitionWasCancelled {
                    //return things back!
                    fromController.groupContainerWidthConstraint.constant = toController.view.frame.width
                    fromController.groupView.titlePosition = .center
                    fromController.groupView.headerHeight = headerHeight
                    fromController.groupToTopConstraint.constant = -headerHeight
                    fromController.view.layoutIfNeeded()
                    fromController.navigationController?.isNavigationBarHidden = false
                }
                else {
                    targetCell.alpha = 1
                }
            }
        }
    }
    
}
