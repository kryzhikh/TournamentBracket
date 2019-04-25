//
//  Match+CoreDataClass.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 17/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Match)
public class Match: NSManagedObject {
    
    class func makeMatch(stage: Int32, orderNumber: Int32, player1: Competitor? = nil, player2: Competitor? = nil, context: NSManagedObjectContext) -> Match {
        let m = Match(context: context)
        m.player1 = player1
        m.player2 = player2
        m.number = orderNumber
        m.stage = stage
        return m
    }
    
    func nextBracketMatch(in context: NSManagedObjectContext = CoreData.shared.viewContext) -> Match? {
        let nextStage = stage + 1
        let nextMatchNumber = number / 2
        let fetchRequest = NSFetchRequest<Match>(entityName: "Match")
        fetchRequest.predicate = NSPredicate(format: "stage = %d AND orderNumber = %d", nextStage, nextMatchNumber)
        let matches = try? context.fetch(fetchRequest)
        return matches?.first
    }

}
