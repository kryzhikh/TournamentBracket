//
//  Competitor+CoreDataClass.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 06/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Competitor)
public class Competitor: NSManagedObject {
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }

}
