//
//  WordsSelectionAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//


/// Протокол сборщика экрана выбора части слов из общего списка
protocol WordsSelectionAssemblerProtocol {

	/// Создает экран
	/// - Parameters:
	///   - words: слова доступные для изучения
	///   - alreadySelectedWords: выбранные ранее слова
	///   - actionOnClose: замыкание при закрытии, со списком выбранных слов
	func create(allWords: [Word],
				alreadySelectedWords:[Word],
				actionOnClose: @escaping ([Word]) -> Void) -> WordsSelectionViewControllerProtocol
}

/// Сборщик экрана выбора части слов из общего списка
final class WordsSelectionAssembler: WordsSelectionAssemblerProtocol {

	func create(allWords: [Word],
				alreadySelectedWords:[Word],
				actionOnClose: @escaping ([Word]) -> Void) -> WordsSelectionViewControllerProtocol {

		let interactor = WordsSelectionInteractor(words: allWords,
												  alreadySelectedWords: alreadySelectedWords,
												  actionOnClose: actionOnClose)
		let viewController = WordsSelectionViewController(interactor: interactor)
		let presenter = WordsSelectionPresenter(viewController: viewController)
		interactor.presenter = presenter

		return viewController
	}
}
