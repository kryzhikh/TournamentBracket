//
//  Style.swift
//  Tournament Bracket
//
//  Created by Konstantin Ryzhikh on 11/03/2019.
//  Copyright © 2019 Distillery. All rights reserved.
//

import Foundation
import UIKit

struct ViewStyle<T: UIView> {
    let applyStyle: (T) -> Void
}

extension ViewStyle where T: UIButton {
    static var filled: ViewStyle<T> {
        return ViewStyle<T> {
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .red
        }
    }
}

extension ViewStyle where T: UIView {
    static var rounded: ViewStyle<T> {
        return ViewStyle<T> {
            $0.layer.cornerRadius = 5
        }
    }
    static var shadowed: ViewStyle<T> {
        return ViewStyle<T> {
            let l = $0.layer
            l.shadowColor = UIColor.black.cgColor
            l.shadowOffset = CGSize(width: 1, height: 1)
            l.shadowRadius = 3
            l.shadowOpacity = 0.1
        }
    }
    static var grayBackground: ViewStyle<T> {
        return ViewStyle<T> {
            $0.backgroundColor = UIColor(hex: 0xF0EFEB)
        }
    }
    static var groupNameBackground: ViewStyle<T> {
        return ViewStyle<T> {
            $0.backgroundColor = UIColor(hex: 0xC9B6FF)
        }
    }
}

protocol Stylable { }
extension UIView: Stylable { }

extension Stylable where Self: UIView {
    func apply(_ style: ViewStyle<Self>) {
        style.applyStyle(self)
    }
}
