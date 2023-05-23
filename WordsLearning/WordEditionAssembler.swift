//
//  WordEditionAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//

import UIKit

/// Протокол сборщика экрана изменения свойств слова
protocol WordEditionAssemblerProtocol {

	/// Создает экран
	/// - Parameter word: слово для изменения
	/// - Parameter actionOnClose: замыкание при закрытии, возвращает обновленные свойства слова, если они были изменены
	func create(for word: Word, actionOnClose: @escaping (EditedWordParts?) -> Void) -> WordEditionViewControllerProtocol
}

/// Сборщик экрана изменения свойств слова
final class WordEditionAssembler: WordEditionAssemblerProtocol {

	func create(for word: Word, actionOnClose: @escaping (EditedWordParts?) -> Void) -> WordEditionViewControllerProtocol {
		let interactor = WordEditionInteractor(storageService: StorageService(specificStorage: CoreDataDAO()),
											   word: word,
											   actionOnClose: actionOnClose)
		let viewController = WordEditionViewController(interactor: interactor)
		let presenter = WordEditionPresenter(viewController: viewController)
		interactor.presenter = presenter

		return viewController
	}
}
