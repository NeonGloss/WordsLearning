//
//  WordsListsSelectionAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол сборщика экрана выбора списка слов для изучения
protocol WordsListsSelectionAssemblerProtocol {

	/// Создает экран
	/// - Parameters:
	///   - actionOnClose: замыкание при закрытии, возвращает список слов для изучения
	///   - currentlySelectedWordsList: текущий список слов
	func create(currentWordsList: WordsList?,
				actionOnClose: @escaping (WordsList?) -> Void) -> WordsListsSelectionViewControllerProtocol
}

/// Сборщик экрана выбора списка слов для изучения
final class WordsListsSelectionAssembler: WordsListsSelectionAssemblerProtocol {

	func create(currentWordsList: WordsList?,
				actionOnClose: @escaping (WordsList?) -> Void) -> WordsListsSelectionViewControllerProtocol {
		let router = MainRouter()
		let interactor = WordsListsSelectionInteractor(router: router,
													   storageService: StorageService(specificStorage: CoreDataDAO()),
													   currentWordsList: currentWordsList,
													   actionOnClose: actionOnClose)
		let viewController = WordsListsSelectionViewController(interactor: interactor)
		let presenter = WordsListsSelectionPresenter(viewController: viewController, alertService: AlertService())
		interactor.presenter = presenter
		router.viewController = viewController
		return viewController
	}
}
