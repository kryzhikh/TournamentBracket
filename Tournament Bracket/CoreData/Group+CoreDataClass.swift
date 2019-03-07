//
//  Group+CoreDataClass.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 06/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Group)
public class Group: NSManagedObject {
    
    convenience init(name: String, competitors: [Competitor] = [], context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.competitors = NSOrderedSet(array: competitors)
    }
    
    convenience init(name: String, competitorsNames: [String] = [], context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        var competitors = [Competitor]()
        for name in competitorsNames {
            let competitor = Competitor(name: name, context: context)
            competitors.append(competitor)
        }
        self.competitors = NSOrderedSet(array: competitors)
    }

}
