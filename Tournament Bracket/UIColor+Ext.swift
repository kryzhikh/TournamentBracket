//
//  UIColor+Ext.swift
//  Collected
//
//  Created by Konstantin Ryzhikh on 21.06.2018.
//  Copyright © 2018 MyCollected. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red255: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) {
        self.init(red: red255 / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    convenience init(white255: CGFloat, alpha: CGFloat = 1) {
        self.init(white: white255 / 255.0, alpha: alpha)
    }
    
    convenience init(hex: Int, alpha: CGFloat = 1) {
        self.init(red255: CGFloat((hex >> 16) & 0xFF),
                  green: CGFloat((hex >> 8) & 0xFF),
                  blue: CGFloat(hex & 0xFF),
                  alpha: alpha)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1) {
        guard hex.hasPrefix("#") else {
            self.init(white255: 255)
            return
        }
        let str = hex.dropFirst()
        guard str.count == 6, let hex = Int(str, radix: 16) else {
            self.init(white255: 255)
            return
        }
        self.init(hex: hex, alpha: alpha)
    }
    
    static func hex(_ hex: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(hex: hex)
    }
    
    //https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor/42381754
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }
        else {
            return nil
        }
    }
}
