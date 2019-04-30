//
//  StoryboardLoadable.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 29/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

protocol StoryboardInstantiatable {
    static var storyboardId: String { get }
    static var storyboardName: String { get }
    static func instantiateFromStoryboard() -> Self
}

extension StoryboardInstantiatable where Self: UIViewController {
    static func instantiateFromStoryboard() -> Self {
        let s = UIStoryboard(name: storyboardName, bundle: nil)
        let vc = s.instantiateViewController(withIdentifier: storyboardId) as! Self
        return vc
    }
}
