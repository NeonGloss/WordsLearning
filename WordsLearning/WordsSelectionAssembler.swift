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
	///   - storageService: сервис хранения данных
	///   - editingList: список для изменения
	///   - actionOnClose: замыкание при закрытии, возвращает флаг - был ли список изменен
	func create(storageService: WordsListStorageServiceProtocol,
				editingList:WordsList?,
				actionOnClose: @escaping (Bool) -> Void) -> WordsSelectionViewControllerProtocol
}

/// Сборщик экрана выбора части слов из общего списка
final class WordsSelectionAssembler: WordsSelectionAssemblerProtocol {

	func create(storageService: WordsListStorageServiceProtocol,
				editingList:WordsList?,
				actionOnClose: @escaping (Bool) -> Void) -> WordsSelectionViewControllerProtocol {
		let interactor = WordsSelectionInteractor(storageService: storageService,
												  editingList: editingList,
												  actionOnClose: actionOnClose)
		let viewController = WordsSelectionViewController(interactor: interactor)
		let presenter = WordsSelectionPresenter(viewController: viewController)
		interactor.presenter = presenter

		return viewController
	}
}
