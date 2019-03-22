//
//  GroupView.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 21/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

@IBDesignable
class GroupView: UIView {

    let groupTable = GroupTableView()
    let titleBackground = UIView()
    let titleLabel = UILabel()
    
    let titleHeight: CGFloat = 44
    let titleLeftOffset: CGFloat = 20
    
    @IBInspectable var titleBackgroundColor: UIColor = .white {
        didSet {
            titleBackground.backgroundColor = titleBackgroundColor
        }
    }
    
    @IBInspectable var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        [groupTable, titleBackground, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [groupTable, titleBackground].forEach { addSubview($0) }
        titleBackground.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: topAnchor),
            titleBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleBackground.heightAnchor.constraint(equalToConstant: titleHeight),
            groupTable.topAnchor.constraint(equalTo: titleBackground.bottomAnchor),
            groupTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            groupTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTable.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleBackground.leadingAnchor, constant: titleLeftOffset),
            titleLabel.centerYAnchor.constraint(equalTo: titleBackground.centerYAnchor)
            ])
    }

}
