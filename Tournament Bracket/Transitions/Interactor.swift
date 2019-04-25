//
//  Interactor.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 05/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
    
    func interactWith(_ pan: UIPanGestureRecognizer, movementPercent: CGFloat, shouldFinish: Bool, transitionContext: UIViewControllerContextTransitioning?) {
        switch pan.state {
        case .changed:
            update(movementPercent)
            self.shouldFinish = shouldFinish
        case .cancelled, .failed:
            hasStarted = false
            cancel()
            transitionContext?.cancelInteractiveTransition()
        case .ended:
            hasStarted = false
            if shouldFinish {
                finish()
            }
            else {
                cancel()
                transitionContext?.cancelInteractiveTransition()
            }
        default:
            break
        }
    }
}
