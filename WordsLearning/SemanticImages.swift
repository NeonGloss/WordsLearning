//
//  SemanticImages.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.08.2022.
//

import UIKit

final class SemanticImages {

	static var checkmarkCircle: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .green])
		return UIImage(systemName: "checkmark.circle.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var wrongCircle: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .red])
		return UIImage(systemName: "multiply.circle.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var editionPen: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "square.and.pencil")?.applyingSymbolConfiguration(config) ?? UIImage()
	}
}
