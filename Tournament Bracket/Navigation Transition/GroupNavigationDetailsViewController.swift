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
