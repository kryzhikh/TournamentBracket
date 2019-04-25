//
//  GroupTableView.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 05/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class GroupTableView: UITableView {
    
    var group: Group? {
        didSet {
            reloadData()
            setConstraints()
        }
    }

    private override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        register(UINib(nibName: GroupTableCell.nibName, bundle: nil), forCellReuseIdentifier: GroupTableCell.reuseId)
        rowHeight = GroupTableCell.cellHeight
        estimatedRowHeight = GroupTableCell.cellHeight
        delegate = self
        dataSource = self
        isUserInteractionEnabled = false
        tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
    }
    
    func setConstraints() {
        let competitorsCount = group?.competitors?.count ?? 0
        let height = CGFloat(competitorsCount) * GroupTableCell.cellHeight
        removeConstraints(constraints)
//        widthAnchor.constraint(equalToConstant: tableWidth).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
}

extension GroupTableView: UITableViewDelegate {

}

extension GroupTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.competitors?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(GroupTableCell.self, for: indexPath)
        if let c = group?.competitors?[indexPath.row] as? Competitor {
            cell.nameLabel.text = c.name
            cell.scoreLabel.text = String(c.groupScore)
        }
        return cell
    }
    
}
