//
//  MainAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол сборщика экрана
protocol MainAssemblerProtocol {

	/// Создает экран
	/// - Parameter navigationController: контроллер навигации
	/// - Returns вью-контроллер для отображения
	func createMainScene(with navigationController: UINavigationController) ->
																		MainViewControllerProtocol
}

/// Сборщик экрана
final class MainAssembler: MainAssemblerProtocol {

	func createMainScene(with navigationController: UINavigationController) -> MainViewControllerProtocol {
		let storageService = StorageService(specificStorage: KeychainStorageService(keychainWrapper: KeychainWrapper()))
		let router = MainRouter()
		let interactor = MainInteractor(router: router, quizService: QuizService(), storageService: storageService)
		let viewController = MainViewController(interactor: interactor)
		let presenter = MainPresenter(viewController: viewController, alertService: AlertService())
		router.viewController = viewController
		interactor.presenter = presenter

		return viewController
	}
}
