//
//  BracketCell.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 15/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class BracketCell: UIView {

    private let nameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let imageView = UIImageView()
    
    var stage = 0
    var index = 0
    
    private let imageMargin: CGFloat = 10
    
    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }
    
    var score: UInt? = nil {
        didSet {
            scoreLabel.text = score.map { String($0) } ?? ""
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
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
        [nameLabel, scoreLabel, imageView].forEach { addSubview($0) }
        [nameLabel, scoreLabel, imageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        imageView.image = #imageLiteral(resourceName: "default_player")
        setupConstraints()
        stylize()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: imageMargin),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: imageMargin),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -imageMargin),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -imageMargin),
            scoreLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
    }
    
    private func stylize() {
        apply(.rounded)
        apply(.lightGrayThinBorder)
    }
    
    func fill(forPlayer1In match: Match) {
        name = match.player1?.name ?? ""
        stage = Int(match.stage)
        index = Int(match.number * 2)
        if name.isEmpty {
            name = "Stage \(stage)"
        }
    }
    
    func fill(forPlayer2In match: Match) {
        name = match.player2?.name ?? ""
        stage = Int(match.stage)
        index = Int(match.number * 2 + 1)
        if name.isEmpty {
            name = "Stage \(stage)"
        }
    }
    
}
