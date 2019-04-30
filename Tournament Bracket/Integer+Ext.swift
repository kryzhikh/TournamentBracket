//
//  Integer+Ext.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 30/04/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

extension FixedWidthInteger {
    func isPowerOfTwo() -> Bool {
        return Float(self).significand == 1
    }
}
