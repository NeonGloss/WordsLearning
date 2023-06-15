//
//  CustomUIButton.swift
//  WordsLearning
//
//  Created by Roman on 03/06/2023.
//

import UIKit

/// Кнопка с кастомными настройками раскрашиания контента при нажатии
final class CustomUIButton: UIButton {

	override func updateConfiguration() {
		guard let configuration = configuration else {
			return
		}

		var updatedConfiguration = configuration
		var background = UIButton.Configuration.plain().background
		background.cornerRadius = bounds.height / 2
		background.strokeWidth = 0

//		let strokeColor: UIColor
		let foregroundColor: UIColor
		let backgroundColor: UIColor
		let baseColor = updatedConfiguration.baseForegroundColor ?? UIColor.tintColor

		switch self.state {
		case .normal:
//			strokeColor = .systemGray5
			foregroundColor = baseColor
			backgroundColor = .clear
		case [.highlighted]:
//			strokeColor = .systemGray5
			imageView?.image = imageView?.image?.coloredAs(.blue, .blue)
			foregroundColor = baseColor
			backgroundColor = baseColor.withAlphaComponent(0.7)
		case .selected:
//			strokeColor = .clear
			foregroundColor = .white
			backgroundColor = baseColor

		case [.selected, .highlighted]:
//			strokeColor = .clear
			foregroundColor = .white
			backgroundColor = baseColor//.darker()
		case .disabled:
//			strokeColor = .systemGray6
			foregroundColor = baseColor//.withAlphaComponent(0.3)
			backgroundColor = .clear
		default:
//			strokeColor = .systemGray5
			foregroundColor = baseColor
			backgroundColor = .clear
		}

//		background.strokeColor = strokeColor
		background.backgroundColorTransformer = UIConfigurationColorTransformer { color in
			return backgroundColor
		}

		updatedConfiguration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
			var container = incoming
			container.foregroundColor = foregroundColor
			return container
		}

		updatedConfiguration.background = background
		self.configuration = updatedConfiguration
	}
}

extension UIColor {

	func darker() -> UIColor {
		var r:CGFloat = 0
		var g:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 0

		if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
		}

		return UIColor()
	}
}

