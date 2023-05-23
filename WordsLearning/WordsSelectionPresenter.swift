//
//  WordsSelectionPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол презентера сцены выбора слов для изучения
protocol WordsSelectionPresenterProtocol {
	
	/// Отобразить элементы таблицы
	/// - Parameters:
	///  - listName: название списка
	///  - items: элементы таблицы
	///  - selectedWordsCount: количество слов в списке
	func present(listName: String?, items: [DRTableViewCellProtocol], selectedWordsCount: Int)
	
	/// Отобразить количество выбранных слов
	/// - Parameter numberOfSelectedWords: количество выбранных слов
	func setSelectedWordCountTo(_ numberOfSelectedWords: Int)
	
	/// Очистить выделение
	func clearSelection()
	
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
	
	func present(listName: String?, items: [DRTableViewCellProtocol], selectedWordsCount: Int) {
		viewController?.setNameTo(listName)
		viewController?.displayItems(items)
		viewController?.setSelectedWordCountTo(selectedWordsCount)
	}
	
	func setSelectedWordCountTo(_ numberOfSelectedWords: Int) {
		viewController?.setSelectedWordCountTo(numberOfSelectedWords)
	}
	
	func clearSelection() {
		viewController?.deselectAllWords()
		viewController?.setSelectedWordCountTo(0)
	}
	
	func closeScene() {
		viewController?.closeScene()
	}
}
