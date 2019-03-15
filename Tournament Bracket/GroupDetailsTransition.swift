//
//  GroupDetailsTransition.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 15/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
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
            let toController = transitionContext.viewController(forKey: .to) as! GroupDetailsViewController
            let fromController = transitionContext.viewController(forKey: .from) as! ViewController
            toController.view.frame = containerView.frame
            let ip = toController.indexPath
            let cell = fromController.transitionCollectionView.cellForItem(at: ip)!
            let snapshot = cell.snapshotView(afterScreenUpdates: false)!
            snapshot.frame = CGRect(origin: cell.convert(cell.frame.origin, to: containerView), size: cell.frame.size)
            containerView.addSubview(fromController.view)
            containerView.addSubview(toController.view)
            containerView.addSubview(snapshot)
            let toOrigin = toController.groupContainer.convert(toController.groupContainer.frame.origin, to: nil)
            UIView.animate(withDuration: duration, animations: {
                snapshot.frame.origin = toOrigin
                fromController.view.alpha = 0
            }) { finished in
                //                if finished {
                snapshot.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                //                }
            }
        }
    }
    
    
}
