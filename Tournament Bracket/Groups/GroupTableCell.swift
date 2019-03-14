//
//  GroupTableCell.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupTableCell: UITableViewCell, Reusable {
    
    static let nibName = "GroupTableCell"
    static let reuseId = "GroupTableCell"
    static let cellHeight: CGFloat = 44

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }    
}
