//
//  WordsSelectionPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол презентера сцены выбора слов для изучения
protocol WordsSelectionPresenterProtocol {
	
	func presentItems(_ items: [DRTableViewCellProtocol])
	
	/// Отобразить количество выбранных слов
	/// - Parameter numberOfSelectedWords: количество выбранных слов
	func setSelectedWordCountTo(_ numberOfSelectedWords: Int)
	
	/// Очистить выделение
	/// - Parameter numberOfAllWords: общее количество слов
	func cleanSelection(numberOfAllWords: Int)
	
	/// Закрыть сцену
	func closeScene()
}

/// Презентер сцены выбора слов для изучения
final class WordsSelectionPresenter: WordsSelectionPresenterProtocol {
	
	private weak var viewController: WordsSelectionViewControllerProtocol?
	
	/// Инициализатор
	/// - Parameter viewController: вью-контроллер сцены
	init(viewController: WordsSelectionViewControllerProtocol) {
		self.viewController = viewController
	}
	
	func presentItems(_ items: [DRTableViewCellProtocol]) {
		viewController?.displayItems(items)
	}
	
	func setSelectedWordCountTo(_ numberOfSelectedWords: Int) {
		viewController?.setSelectedWordCountTo(numberOfSelectedWords)
	}
	
	func cleanSelection(numberOfAllWords: Int) {
		viewController?.deselectAllWords()
		viewController?.setSelectedWordCountTo(numberOfAllWords)
	}
	
	func closeScene() {
		viewController?.closeScene()
	}
}
