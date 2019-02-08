//
//  UIColor+Extension.swift
//  SwiftFireChat
//
//  Created by Dino Pelic on 2/9/19.
//  Copyright © 2019 Dino Pelic. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
