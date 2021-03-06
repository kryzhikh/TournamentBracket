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
    
    @IBOutlet weak var groupView: GroupView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.apply(.rounded)
        contentView.clipsToBounds = true
        apply(.shadowed)
        contentView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    }
    
    func fill(with group: Group) {
        groupView.groupTable.group = group
        groupView.title = "Group " + (group.name?.uppercased() ?? "")
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
//        frame.size.width = ceil(size.width)
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }

}
