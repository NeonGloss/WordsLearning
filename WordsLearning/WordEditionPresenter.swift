//
//  WordEditionPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//

/// Протокол презентера сцены изменения свойств слова
protocol WordEditionPresenterProtocol {

	func fillUIWith(_ word: Word)
  
	func dismissScene()
}

/// Презентер сцены изменения свойств слова
final class WordEditionPresenter: WordEditionPresenterProtocol {

	private weak var viewController: WordEditionViewControllerProtocol?

	/// Инициализатор
	/// - Parameter viewController: вью-контроллер сцены
	init(viewController: WordEditionViewControllerProtocol) {
		self.viewController = viewController
	}

	func fillUIWith(_ word: Word) {
		guard let viewController = viewController else { return }
		let nativeString = word.native.reduce("") { !$0.isEmpty ? [$0, $1].joined(separator: ",") : $1 }
		viewController.fillWith(foreign: word.foreign,
								native: nativeString,
								fToNRemark: word.fToNRemark,
								nToFRemark: word.nToFRemark,
								transctription: word.transcription)
	}

	func dismissScene() {
		viewController?.dismiss(animated: true)
	}
}
