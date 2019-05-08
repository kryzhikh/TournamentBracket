//
//  BracketViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 15/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit
import CoreData

class BracketViewController: UIViewController, StoryboardInstantiatable {
    
    static let storyboardId = "BracketViewController"
    static let storyboardName = "Main"
    
    private let margin: CGFloat = 30
    private let verticalDistance: CGFloat = 20
    private let horizontalDistance: CGFloat = 20
    private let cellSize = CGSize(width: 150, height: 80)
    
    private var bracketPopulated = false
    
    var tournament: Tournament!
    var matches: [Match] {
        return (tournament.bracket?.matches ?? []).allObjects as! [Match]
    }
    
    private var cells: [BracketMatchCell] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.apply(.grayBackground)
        
//        prepareStubData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !bracketPopulated {
            populateBracket(for: matches)
            addLines(for: matches)
            bracketPopulated = true
        }
    }
    
    func matchSelected(_ match: Match) {
        
    }
    
    
    private func populateBracket(for matches: [Match]) {
        var maxX: CGFloat = 0, maxY: CGFloat = 0
        
        for m in matches {
            let cell = BracketMatchCell()
            cell.match = m
            cell.tapped = { [weak self] m in self?.matchSelected(m) }
            cells.append(cell)
            scrollView.addSubview(cell)
            cell.frame.size = cellSize
            
            let x = getMatchCellX(forStage: Int(m.stage), margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
            let y = getMatchCellY(forStage: Int(m.stage), matchNumber: Int(m.number), cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            cell.frame.origin = CGPoint(x: x, y: y)
            if cell.frame.maxX > maxX {
                maxX = cell.frame.maxX
            }
            if cell.frame.maxY > maxY {
                maxY = cell.frame.maxY
            }
        }
        
        scrollView.contentSize = CGSize(width: max(scrollView.frame.width, maxX + margin), height: max(calculateBracketHeight(), scrollView.frame.height))
    }
    
    private func calculateBracketHeight() -> CGFloat {
        let maxMatchNumber = matches.filter { $0.stage == 0 }.map { $0.number }.max() ?? 0
        let lastMatchMinY = margin + CGFloat(maxMatchNumber) * (cellSize.height + verticalDistance)
        let lastMatchMaxY = lastMatchMinY + cellSize.height
        return lastMatchMaxY + margin
    }
    
    private func addLines(for matches: [Match]) {
        let linesView = UIView(frame: CGRect(origin: .zero, size: scrollView.contentSize))
        let linesLayer = CAShapeLayer()
        linesLayer.bounds = linesLayer.bounds
        let linesPath = UIBezierPath()
        for m in matches {
            guard m.stage > 0 else { continue }
            let x = getMatchCellX(forStage: Int(m.stage), margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
            let y = getMatchCellY(forStage: Int(m.stage), matchNumber: Int(m.number), cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            let prevX = getMatchCellX(forStage: Int(m.stage) - 1, margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
            let prevUpperY = getMatchCellY(forStage: Int(m.stage) - 1, matchNumber: Int(m.number) * 2, cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            let prevLowerY = getMatchCellY(forStage: Int(m.stage) - 1, matchNumber: Int(m.number) * 2 + 1, cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            let frame = CGRect(origin: CGPoint(x: x, y: y), size: cellSize)
            let prevUpperFrame = CGRect(origin: CGPoint(x: prevX, y: prevUpperY), size: cellSize)
            let prevLowerFrame = CGRect(origin: CGPoint(x: prevX, y: prevLowerY), size: cellSize)
            
            linesPath.move(to: CGPoint(x: prevUpperFrame.maxX, y: prevUpperFrame.midY))
            linesPath.addLine(to: CGPoint(x: prevUpperFrame.maxX + horizontalDistance / 2, y: prevUpperFrame.midY))
            linesPath.addLine(to: CGPoint(x: prevUpperFrame.maxX + horizontalDistance / 2, y: frame.midY))
            linesPath.addLine(to: CGPoint(x: prevUpperFrame.maxX + horizontalDistance,     y: frame.midY))
            linesPath.move(to: CGPoint(x: prevLowerFrame.maxX, y: prevLowerFrame.midY))
            linesPath.addLine(to: CGPoint(x: prevLowerFrame.maxX + horizontalDistance / 2, y: prevLowerFrame.midY))
            linesPath.addLine(to: CGPoint(x: prevLowerFrame.maxX + horizontalDistance / 2, y: frame.midY))
        }
        
        linesLayer.path = linesPath.cgPath
        linesLayer.lineWidth = 1
        linesLayer.strokeColor = UIColor.lightGray.cgColor
        linesLayer.fillColor = UIColor.clear.cgColor
        linesView.layer.addSublayer(linesLayer)
        scrollView.insertSubview(linesView, at: 0)
    }
    
    private func getMatchCellX(forStage stage: Int, margin: CGFloat, cellWidth: CGFloat, horizontalDistance: CGFloat) -> CGFloat {
        return margin + CGFloat(stage) * (cellSize.width + horizontalDistance)
    }
    
    private func getMatchCellY(forStage stage: Int, matchNumber: Int, cellHeight: CGFloat, verticalDistance: CGFloat, margin: CGFloat) -> CGFloat {
        if stage == 0 {
            var y = margin + CGFloat(matchNumber) * (cellSize.height + verticalDistance)
            let bracketHeight = calculateBracketHeight()
            if bracketHeight < scrollView.frame.height {
                let offset = (scrollView.frame.height - bracketHeight) / 2
                y += offset
            }
            return y
        }
        else {
            let prevStage = stage - 1
            let prevStageMatch1Number = matchNumber * 2
            let prevStageMatch2Number = matchNumber * 2 + 1
            let prevStageMatch1CellY = getMatchCellY(forStage: prevStage, matchNumber: prevStageMatch1Number, cellHeight: cellHeight, verticalDistance: verticalDistance, margin: margin)
            let prevStageMatch2CellY = getMatchCellY(forStage: prevStage, matchNumber: prevStageMatch2Number, cellHeight: cellHeight, verticalDistance: verticalDistance, margin: margin)
            let prevStageMatch2CellYMaxY = prevStageMatch2CellY + cellHeight
            let prevPairCenterY = prevStageMatch1CellY + (prevStageMatch2CellYMaxY - prevStageMatch1CellY) / 2
            return prevPairCenterY - cellHeight / 2
        }
    }
    
    private func prepareStubData() {
        let groupsDict = ["A": ["Vasili", "Petr", "Ivan", "Valera"],
                          "B": ["Mike", "John", "Tom", "Jerry"],
                          "C": ["Jovanni", "Alejandro", "Marko", "Polo"],
                          "D": ["Chan", "Chen", "Zhao", "Minzi"]]
        let names = groupsDict.flatMap { $1 }
        let context = CoreData.shared.viewContext
        tournament = Tournament.makeBracketTournament(name: "Bracket T", competitorsNames: names, context: context)
        print(names)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    deinit {
        print("DEINITING BVC")
    }

}
