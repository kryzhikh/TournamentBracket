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
import UIKit

@objc(Competitor)
public class Competitor: NSManagedObject {
    
    var image: UIImage {
        let defaultImage = #imageLiteral(resourceName: "default_player")
        return imageURL.flatMap { UIImage(url: $0) } ?? defaultImage
    }
    
    convenience init(name: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
    }

}
