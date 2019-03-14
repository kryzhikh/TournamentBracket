//
//  GroupDetailsViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 12/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupDetailsViewController: UIViewController {
    
    @IBOutlet weak var groupTableView: GroupTableView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var group: Group? {
        didSet {
            if groupTableView != nil && groupNameLabel != nil {
                groupTableView.group = group
                groupNameLabel.text = "Group " + (group?.name ?? "")
            }
        }
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
