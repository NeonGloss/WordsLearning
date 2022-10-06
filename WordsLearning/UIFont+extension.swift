//
//  UIFont+extension.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 01.08.2022.
//

import UIKit

extension UIFont {

	func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
		guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
			return UIFont()
		}
		return UIFont(descriptor: descriptor, size: 0)
	}

	func bold() -> UIFont {
		return withTraits(traits: .traitBold)
	}


	func italic() -> UIFont {
		return withTraits(traits: .traitItalic)
	}
}
