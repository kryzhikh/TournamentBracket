//
//  TransitionService.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 11/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class TransitionService: NSObject {
    let interactor = Interactor()
    let modalTransition = GroupDetailsTransition(duration: 0.5, isPresenting: false)
    let navigationTransition = GroupDetailsNavigationTransition(duration: 0.5, isPresenting: false)
}

//MARK: - Custom navigation controller transition
extension TransitionService {
    func navigationControllerTransitioning(for operation: UINavigationController.Operation) -> UIViewControllerAnimatedTransitioning? {
        navigationTransition.isPresenting = operation == .push
        return navigationTransition
    }
    
    func navigationControllerInteractiveTransitioning() -> UIViewControllerInteractiveTransitioning? {
        return !navigationTransition.isPresenting && interactor.hasStarted ? interactor : nil
    }
}

//MARK: - Custom modal transition
extension TransitionService: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalTransition.isPresenting = false
        return modalTransition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalTransition.isPresenting = true
        return modalTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
