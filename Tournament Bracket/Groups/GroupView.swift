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
    
    @objc enum TitlePosition: Int {
        case left, center, right
    }

    let groupTable = GroupTableView()
    private let headerView = UIView()
    private let titleLabel = UILabel()
    
    private var leftTitleConstraint: NSLayoutConstraint!
    private var rightTitleConstraint: NSLayoutConstraint!
    private var centeredTitleConstraint: NSLayoutConstraint!
    private var titleHeightConstraint: NSLayoutConstraint!
    private var headerHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable var titleHeight: CGFloat = 44 {
        didSet {
            titleHeightConstraint.constant = titleHeight
        }
    }
    @IBInspectable var headerHeight: CGFloat = 44 {
        didSet {
            headerHeightConstraint.constant = headerHeight
        }
    }
    
    @IBInspectable var titleSideOffset: CGFloat = 20
        {
        didSet {
            leftTitleConstraint.constant = titleSideOffset
            rightTitleConstraint.constant = -titleSideOffset
        }
    }
    
    @IBInspectable var titlePosition: TitlePosition = .left {
        didSet {
            switch titlePosition {
            case .left:
                leftTitleConstraint.isActive = true
                rightTitleConstraint.isActive = false
                centeredTitleConstraint.isActive = false
            case .right:
                leftTitleConstraint.isActive = false
                rightTitleConstraint.isActive = true
                centeredTitleConstraint.isActive = false
                
            case .center:
                leftTitleConstraint.isActive = false
                rightTitleConstraint.isActive = false
                centeredTitleConstraint.isActive = true
            }
        }
    }
    
    @IBInspectable var titleBackgroundColor: UIColor = .white {
        didSet {
            headerView.backgroundColor = titleBackgroundColor
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
        [groupTable, headerView, titleLabel].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        [groupTable, headerView].forEach { addSubview($0) }
        headerView.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        setConstraints()
        setTitleConstraint()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTable.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            groupTable.trailingAnchor.constraint(equalTo: trailingAnchor),
            groupTable.leadingAnchor.constraint(equalTo: leadingAnchor),
            groupTable.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
//            titleLabel.leadingAnchor.constraint(equalTo: titleBackground.leadingAnchor, constant: titleSideOffset),
//            titleLabel.centerYAnchor.constraint(equalTo: titleBackground.centerYAnchor),
            ])
    }
    
    private func setTitleConstraint() {
        leftTitleConstraint = titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: titleSideOffset)
        rightTitleConstraint = titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -titleSideOffset)
        centeredTitleConstraint = titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor)
        
        titleHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: titleHeight)
        headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerHeight)

        [titleHeightConstraint, headerHeightConstraint, leftTitleConstraint].forEach { $0?.isActive = true }
    }

}
