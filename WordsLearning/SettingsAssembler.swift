//
//  SettingsAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.09.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол сборщика экрана
protocol SettingsAssemblerProtocol {

	/// Создает экран
	func create() -> UIViewController
}

/// Сборщик экрана
final class SettingsAssembler: SettingsAssemblerProtocol {

	func create() -> UIViewController {
		let router = SettingsRouter()
		let interactor = SettingsInteractor(router: router, service: SettingsService())
		let viewController = SettingsViewController(interactor: interactor)
		let presenter = SettingsPresenter(viewController: viewController)
		interactor.presenter = presenter
		router.viewController = viewController

		let navigationController = UINavigationController(rootViewController: viewController)
		return navigationController
	}
}
