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
    
    var indexPath = IndexPath(row: 0, section: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
