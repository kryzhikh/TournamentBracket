//
//  GroupDetailsViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 12/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController, CollectionDetailsTransitionable {
    
    @IBOutlet weak var groupContainer: UIView!
    @IBOutlet weak var groupTableView: GroupTableView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    var group: Group? {
        didSet {
            if groupTableView != nil && groupNameLabel != nil {
                groupTableView.group = group
                groupNameLabel.text = "Group " + (group?.name ?? "")
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
        groupTableView.group = group
        groupNameLabel.text = "Group " + (group?.name ?? "")
    }
    
    @objc func close() {
        dismiss(animated: true)
    }

}

extension GroupDetailsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GroupDetailsTransition(duration: 0.3, isPresenting: false)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GroupDetailsTransition(duration: 0.3, isPresenting: true)
    }
}
