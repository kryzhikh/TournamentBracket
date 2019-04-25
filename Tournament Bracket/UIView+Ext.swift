//
//  UIView+Ext.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 14/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import UIKit

extension UIView {
    func makeSnapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        layer.render(in: context)
        let image = UIImage(cgImage: context.makeImage()!)
        UIGraphicsEndImageContext()
        return image
    }
}
