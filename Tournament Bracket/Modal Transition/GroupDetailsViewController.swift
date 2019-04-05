//
//  GroupDetailsViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 12/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController {
    
    @IBOutlet weak var groupContainerView: UIView!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var groupCardWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupView: GroupView!
    
    let transition = GroupDetailsTransition(duration: 0.4, isPresenting: false)
    let interactor = Interactor()
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    var group: Group? {
        didSet {
            if groupView != nil {
                setupGroup()
            }
        }
    }
    
    var groupCardWidth: CGFloat = 0 {
        didSet {
            if groupCardWidthConstraint != nil {
                groupCardWidthConstraint.constant = groupCardWidth
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        setupGroup()
        groupView.apply(.rounded)
        groupContainerView.apply(.rounded)
        groupContainerView.apply(.shadowed)
        view.apply(.grayBackground)
        contentContainer.apply(.grayBackground)
        groupCardWidthConstraint.constant = groupCardWidth
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        groupView.addGestureRecognizer(pan)
    }
    
    @objc func viewPanned(_ pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = max(verticalMovement , 0)
        let movementPercent = min(downwardMovement, 1)
        let threshold: CGFloat = 0.2
//        print(movementPercent)
        switch pan.state {
        case .began:
            interactor.hasStarted = true
            transition.cancelled = false
            dismiss(animated: true)
        case .changed:
            interactor.update(movementPercent)
            interactor.shouldFinish = movementPercent > threshold || pan.velocity(in: self.view).y > 1000
        case .cancelled, .failed:
            interactor.hasStarted = false
            interactor.cancel()
            transition.context?.cancelInteractiveTransition()
        case .ended:
            print(pan.velocity(in: self.view))
            interactor.hasStarted = false
            if interactor.shouldFinish {
                interactor.finish()
            }
            else {
                interactor.cancel()
                transition.context?.cancelInteractiveTransition()
            }
            
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setupGroup() {
        groupView.groupTable.group = group
        groupView.title = "Group " + (group?.name ?? "")
    }
    
    @objc func close() {
        dismiss(animated: true)
    }

}

extension GroupDetailsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }

}
