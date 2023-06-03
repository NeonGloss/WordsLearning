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

	static var questionMarkCircleFill: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .red])
		return UIImage(systemName: "questionmark.circle.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var editionPen: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "square.and.pencil")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var squareGrid: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "square.grid.2x2")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var rectangleGridFill: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "rectangle.grid.2x2.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var pencil: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "pencil")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var sliderHorizontal3: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "slider.horizontal.3")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var leftChevron: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "chevron.backward")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var xmark: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "xmark")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var checkmark: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "checkmark")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var repeatArrows: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "repeat")?.applyingSymbolConfiguration(config) ?? UIImage()
	}

	static var shuffle: UIImage {
		let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
		return UIImage(systemName: "shuffle")?.applyingSymbolConfiguration(config) ?? UIImage()
	}
    
    static var dotCircleAndHandPointUpLeftFill: UIImage {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
        return UIImage(systemName: "dot.circle.and.hand.point.up.left.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
    }
    
    static var plusCircle: UIImage {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
        return UIImage(systemName: "plus.circle")?.applyingSymbolConfiguration(config) ?? UIImage()
    }
    
    static var plusCircleFill: UIImage {
        let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
        return UIImage(systemName: "plus.circle.fill")?.applyingSymbolConfiguration(config) ?? UIImage()
    }

	static var arrowLeftArrowRight: UIImage {
	 let config = UIImage.SymbolConfiguration(paletteColors: [.white, .white])
	 return UIImage(systemName: "arrow.left.arrow.right")?.applyingSymbolConfiguration(config) ?? UIImage()
 }
}
