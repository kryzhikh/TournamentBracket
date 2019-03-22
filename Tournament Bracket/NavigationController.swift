//
//  NavigationController.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 22/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        return viewControllers.last
    }

}
