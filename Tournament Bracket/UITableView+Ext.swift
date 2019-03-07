//
//  UITableView+Ext.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 07/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell & Reusable>(_ type: T.Type, for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: type.reuseId, for: indexPath) as! T
    }
}

