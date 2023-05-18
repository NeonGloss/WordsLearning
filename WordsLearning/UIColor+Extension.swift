//
//  UIColorExt.swift
//  DailyResults
//
//  Created by Кузин Роман Эдуардович on 24.05.2020.
//  Copyright © 2020 Roman Kuzin. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

	convenience init(hex: String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
			self.init(r: 133, g: 133, b: 133) //gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

		self.init(r: CGFloat((rgbValue & 0xFF0000) >> 16),
				  g: CGFloat((rgbValue & 0x00FF00) >> 8),
				  b: CGFloat(rgbValue & 0x0000FF))
    }
}
