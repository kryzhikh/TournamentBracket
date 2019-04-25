//
//  BracketMatchCell.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 24/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class BracketMatchCell: UIView {

    private let player1NameLabel = UILabel()
    private let player1ScoreLabel = UILabel()
    private let player1ImageView = UIImageView()
    
    private let player2NameLabel = UILabel()
    private let player2ScoreLabel = UILabel()
    private let player2ImageView = UIImageView()
    
    private let separator = UIView()
    
    private let margin: CGFloat = 10
    
    var match: Match? = nil {
        didSet {
            if let match = match {
                player1NameLabel.text = match.player1?.name
                player2NameLabel.text = match.player2?.name
                player1ScoreLabel.text = match.finished ? String(match.player1Score) : ""
                player2ScoreLabel.text = match.finished ? String(match.player2Score) : ""
                player1ImageView.image = match.player1?.image
                player2ImageView.image = match.player2?.image
            }
            else {
                [player1NameLabel, player2NameLabel, player1ScoreLabel, player2ScoreLabel].forEach { $0.text = "" }
            }
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
        [player1NameLabel, player1ScoreLabel, player1ImageView, player2NameLabel, player2ScoreLabel, player2ImageView, separator].forEach { addSubview($0) }
        [player1NameLabel, player1ScoreLabel, player1ImageView, player2NameLabel, player2ScoreLabel, player2ImageView, separator].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        setupConstraints()
        stylize()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            player1ImageView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            player1ImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            player1ImageView.widthAnchor.constraint(equalTo: player1ImageView.heightAnchor, multiplier: 1),
            
            player2ImageView.topAnchor.constraint(equalTo: player1ImageView.bottomAnchor, constant: margin),
            player2ImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin),
            player2ImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            player2ImageView.widthAnchor.constraint(equalTo: player2ImageView.heightAnchor, multiplier: 1),
            
            player1ImageView.heightAnchor.constraint(equalTo: player2ImageView.heightAnchor),
            
            player1NameLabel.leadingAnchor.constraint(equalTo: player1ImageView.trailingAnchor, constant: margin),
            player1NameLabel.centerYAnchor.constraint(equalTo: player1ImageView.centerYAnchor),
            
            player2NameLabel.leadingAnchor.constraint(equalTo: player2ImageView.trailingAnchor, constant: margin),
            player2NameLabel.centerYAnchor.constraint(equalTo: player2ImageView.centerYAnchor),
            
            player1ScoreLabel.leadingAnchor.constraint(equalTo: player1NameLabel.trailingAnchor, constant: margin),
            player1ScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            player1ScoreLabel.centerYAnchor.constraint(equalTo: player1NameLabel.centerYAnchor),
            
            player2ScoreLabel.leadingAnchor.constraint(equalTo: player1NameLabel.trailingAnchor, constant: margin),
            player2ScoreLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -margin),
            player2ScoreLabel.centerYAnchor.constraint(equalTo: player1NameLabel.centerYAnchor),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            separator.centerYAnchor.constraint(equalTo: centerYAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            ])
    }
    
    private func stylize() {
        backgroundColor = .white
        apply(.shadowed)
        separator.backgroundColor = UIColor(hex: "#E6E7E8", alpha: 1)
    }

}
