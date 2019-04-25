//
//  BracketViewController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 15/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit
import CoreData

class BracketViewController: UIViewController {
    
    private let margin: CGFloat = 30
    private let verticalDistance: CGFloat = 20
    private let horizontalDistance: CGFloat = 20
    private let cellSize = CGSize(width: 150, height: 80)
    
    var tournament: Tournament!
    
    private var cells: [BracketCell] = []
    private var mCells: [BracketMatchCell] = []

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.apply(.grayBackground)
        
        prepareStubData()
        let matches = (tournament.bracket?.matches ?? []).allObjects as! [Match]
        populateBracket(for: matches)
        addLines(for: matches)
    }
    
    private func populateBracket(for matches: [Match]) {
        var maxX: CGFloat = 0, maxY: CGFloat = 0
        
        for m in matches {
            let cell = BracketMatchCell()
            cell.match = m
            mCells.append(cell)
            scrollView.addSubview(cell)
            cell.frame.size = cellSize
            
            let x = getMatchCellX(for: Int(m.stage), margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
            let y = getMatchCellY(forStage: Int(m.stage), matchNumber: Int(m.number), cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            cell.frame.origin = CGPoint(x: x, y: y)
            if cell.frame.maxX > maxX {
                maxX = cell.frame.maxX
            }
            if cell.frame.maxY > maxY {
                maxY = cell.frame.maxY
            }
        }
        
        scrollView.contentSize = CGSize(width: max(scrollView.frame.width, maxX + margin), height: maxY + margin)
    }
    
    private func addLines(for matches: [Match]) {
        let linesView = UIView(frame: CGRect(origin: .zero, size: scrollView.contentSize))
        let linesLayer = CAShapeLayer()
        linesLayer.bounds = linesLayer.bounds
        let linesPath = UIBezierPath()
        for m in matches {
            guard m.stage > 0 else { continue }
            let x = getMatchCellX(for: Int(m.stage), margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
            let y = getMatchCellY(forStage: Int(m.stage), matchNumber: Int(m.number), cellHeight: cellSize.height, verticalDistance: verticalDistance, margin: margin)
            let prevX = getMatchCellX(for: Int(m.stage) - 1, margin: margin, cellWidth: cellSize.width, horizontalDistance: horizontalDistance)
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
    
    private func getMatchCellX(for stage: Int, margin: CGFloat, cellWidth: CGFloat, horizontalDistance: CGFloat) -> CGFloat {
        return margin + CGFloat(stage) * (cellSize.width + horizontalDistance)
    }
    
    private func getMatchCellY(forStage stage: Int, matchNumber: Int, cellHeight: CGFloat, verticalDistance: CGFloat, margin: CGFloat) -> CGFloat {
        if stage == 0 {
            return margin + CGFloat(matchNumber) * (cellSize.height + verticalDistance)
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

}
