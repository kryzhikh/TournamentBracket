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
    @IBOutlet private weak var groupContentView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var groupTableView: GroupTableView!
    
    @IBOutlet weak var titleToTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    var group: Group? {
        didSet {
            if groupTableView != nil {
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
//        navigationController?.isNavigationBarHidden = false
    }
    
    func setupGroup() {
        groupTableView.group = group
        title = "Group " + (group?.name ?? "")
        titleLabel.text = title
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
