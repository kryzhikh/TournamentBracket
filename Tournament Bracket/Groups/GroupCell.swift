//
//  GroupCell.swift
//  TournamentTables
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    
    static let nibName = "GroupCell"
    static let reuseId = "GroupCell"
    
    @IBOutlet weak var tableView: GroupTableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func fill(with group: Group) {
        tableView.group = group
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        print("Collection content frame: ", self.frame)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        print("Collection cell frame: ", layoutAttributes.frame)
        return layoutAttributes
    }

}
