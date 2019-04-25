//
//  UIImage+Ext.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 25/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(url: URL) {
        if let data = try? Data(contentsOf: url) {
            self.init(data: data, scale: UIScreen.main.scale)
        }
        else {
            return nil
        }
    }
}
