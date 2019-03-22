//
//  GroupDetailsViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 12/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, CollectionDetailsTransitionable {
    
    @IBOutlet weak var groupContainerView: UIView!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var groupCardWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupView: GroupView!
    
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
        return GroupDetailsTransition(duration: 0.4, isPresenting: false)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GroupDetailsTransition(duration: 0.4, isPresenting: true)
    }
}
