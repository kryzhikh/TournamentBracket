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
    
    var transition: GroupDetailsTransition?
    var interactor: Interactor?
    
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
        guard let transition = transition, let interactor = interactor else { return }
        
        let translation = pan.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = max(verticalMovement , 0)
        let movementPercent = min(downwardMovement, 1)
        let threshold: CGFloat = 0.2
        let shouldFinish = movementPercent > threshold || pan.velocity(in: self.view).y > 1000
        
        if case .began = pan.state {
            interactor.hasStarted = true
            dismiss(animated: true)
        }
        
        interactor.interactWith(pan, movementPercent: movementPercent, shouldFinish: shouldFinish, transitionContext: transition.context)
        
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
