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
	/// - Parameter navigationController: контроллер навигации
	/// - Returns вью-контроллер для отображения
	func createSettingsScene(with navigationController: UINavigationController) -> SettingsViewControllerProtocol
}

/// Сборщик экрана
final class SettingsAssembler: SettingsAssemblerProtocol {

	func createSettingsScene(with navigationController: UINavigationController) -> SettingsViewControllerProtocol {
		let interactor = SettingsInteractor(service: SettingsService())
		let viewController = SettingsViewController(interactor: interactor)
		let presenter = SettingsPresenter(viewController: viewController)
		interactor.presenter = presenter

		return viewController
	}
}
