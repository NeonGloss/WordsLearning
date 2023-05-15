//
//  UIImage+extension.swift
//  WordsLearning
//
//  Created by Roman on 15/05/2023.
//

import UIKit

extension UIImage {

	/// Окраска стандартных изображений
	/// - Parameters:
	///   - colorOne: основной цвет
	///   - colorTwo: дополнительный цвет
	func coloredAs(_ colorOne: UIColor, _ colorTwo: UIColor) -> UIImage {
		let colorConfig = UIImage.SymbolConfiguration(paletteColors: [colorOne, colorTwo])
		return self.applyingSymbolConfiguration(colorConfig) ?? UIImage()
	}
}
