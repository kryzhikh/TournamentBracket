//
//  Bracket+CoreDataClass.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 17/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Bracket)
public class Bracket: NSManagedObject {
    
    convenience init(competitors: [Competitor], context: NSManagedObjectContext) {
        self.init(context: context)
        self.competitors = NSOrderedSet(array: competitors, copyItems: false)
        
        var i = 0
        var matches = [Match]()
        while i < competitors.count / 2 {
            let match = Match.makeMatch(stage: 0, orderNumber: Int32(i), player1: competitors[i * 2], player2: competitors[i * 2 + 1], context: context)
            matches.append(match)
            i += 1
        }
        
        var nextStagePlayers = competitors.count / 2
        var stage: Int32 = 1
        while nextStagePlayers > 1 {
            for i in 0..<nextStagePlayers / 2 {
                let match = Match.makeMatch(stage: stage, orderNumber: Int32(i), context: context)
                matches.append(match)
            }
            nextStagePlayers /= 2
            stage += 1
        }
//        matches.append(Match.makeMatch(stage: stage, orderNumber: 0, context: context))
        self.matches = NSSet(array: matches)
    }

}
