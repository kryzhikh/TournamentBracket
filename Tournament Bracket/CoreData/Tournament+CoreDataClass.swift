//
//  Tournament+CoreDataClass.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 10/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tournament)
public class Tournament: NSManagedObject {
    
    convenience init(name: String, groups: [Group], context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.groups = NSOrderedSet(array: groups)
    }
    
    class func makeBracketTournament(name: String, competitorsNames: [String], context: NSManagedObjectContext) -> Tournament {
        let t = self.init(context: context)
        t.name = name
        let competitors = competitorsNames.map { Competitor(name: $0, context: context) }
        t.bracket = Bracket(competitors: competitors, context: context)
        return t
    }

}
