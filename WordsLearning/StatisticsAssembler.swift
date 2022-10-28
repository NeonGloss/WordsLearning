//
//  StatisticsAssembler.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.10.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол сборщика экрана
protocol StatisticsAssemblerProtocol {

	/// Создает экран
	func create() -> UIViewController
}

/// Сборщик экрана
final class StatisticsAssembler: StatisticsAssemblerProtocol {

	func create() -> UIViewController {
		let storageService = StorageService(specificStorage: KeychainStorageService(keychainWrapper: KeychainWrapper()))
		let interactor = StatisticsInteractor(storageService: storageService)
		let viewController = StatisticsViewController(interactor: interactor)
		let presenter = StatisticsPresenter(viewController: viewController)
		interactor.presenter = presenter
		return viewController
	}
}
