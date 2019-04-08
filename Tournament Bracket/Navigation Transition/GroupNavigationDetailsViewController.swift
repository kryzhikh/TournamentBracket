//
//  GroupNavigationDetailsViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 20/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupNavigationDetailsViewController: UIViewController {

    @IBOutlet weak var groupContainer: UIView!
    @IBOutlet weak var groupContentView: UIView!
    @IBOutlet weak var groupView: GroupView!
    
    @IBOutlet weak var groupToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupContainerWidthConstraint: NSLayoutConstraint!
    
    var headerWidth: CGFloat = 0
    var headerToTopOffset: CGFloat = 0
    var titleViewHeight: CGFloat = 0
    
    weak var interactor: Interactor?
    weak var transition: GroupDetailsNavigationTransition?
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    var group: Group? {
        didSet {
            if groupView != nil {
                setupGroup()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGroup()
        navigationController?.navigationBar.barTintColor =  UIColor(hex: 0xC9B6FF)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        pan.edges = .left
        view.addGestureRecognizer(pan)
    }
    
    @objc func viewPanned(_ pan: UIPanGestureRecognizer) {
        guard let transition = transition, let interactor = interactor else { return }
        
        let translation = pan.translation(in: view)
        let hMovement = translation.x / view.bounds.width
        let rightMovement = max(hMovement , 0)
        let movementPercent = min(rightMovement, 1)
        let threshold: CGFloat = 0.3
        let shouldFinish = movementPercent > threshold || pan.velocity(in: self.view).x > 1000
        if case .began = pan.state {
            interactor.hasStarted = true
            navigationController?.popViewController(animated: true)
        }
        
        interactor.interactWith(pan, movementPercent: movementPercent, shouldFinish: shouldFinish, transitionContext: transition.context)
    }
    
    func setupGroup() {
        groupView.groupTable.group = group
        title = "Group " + (group?.name ?? "")
        groupView.title = title ?? ""
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
