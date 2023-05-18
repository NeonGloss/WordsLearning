//
//  MainAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit
import UserNotifications

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
        let notificationService = NotificationService(notificationCenter: UNUserNotificationCenter.current())
        let storageService = StorageService(specificStorage: CoreDataDAO())
        
        let router = MainRouter()
        let interactor = MainInteractor(router: router,
                                        quizService: QuizService(),
                                        storageService: storageService,
                                        notificationService: notificationService)
		let viewController = MainViewController(interactor: interactor)
		let presenter = MainPresenter(viewController: viewController, alertService: AlertService())
		router.viewController = viewController
		interactor.presenter = presenter

		return viewController
	}
}
