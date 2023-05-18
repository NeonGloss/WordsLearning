//
//  WordEditionAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//

import UIKit

/// Протокол сборщика экрана
protocol WordEditionAssemblerProtocol {

	/// Создает экран
	/// - Parameter word: слово для изменения
	/// - Parameter actionOnClose: замыкание при закрытии, с флагом успеха
	func create(for word: Word, actionOnClose: @escaping (EditedWordParts?) -> Void) -> WordEditionViewControllerProtocol
}

/// Сборщик экрана
final class WordEditionAssembler: WordEditionAssemblerProtocol {

	func create(for word: Word, actionOnClose: @escaping (EditedWordParts?) -> Void) -> WordEditionViewControllerProtocol {
		let storageService = StorageService(specificStorage: CoreDataDAO())
		let wordEditionService = WordEditionService(storageService: storageService)
		let interactor = WordEditionInteractor(storageService: wordEditionService,
											   word: word,
											   actionOnClose: actionOnClose)
		let viewController = WordEditionViewController(interactor: interactor)
		let presenter = WordEditionPresenter(viewController: viewController)
		interactor.presenter = presenter

		return viewController
	}
}
