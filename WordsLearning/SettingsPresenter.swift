//
//  SettingsPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.09.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

/// Протокол презентера сцены
protocol SettingsPresenterProtocol {
  
}

/// Презентер сцены
final class SettingsPresenter: SettingsPresenterProtocol {

	private weak var viewController: SettingsViewControllerProtocol?

	/// Инициализатор
	/// - Parameter viewController: вью-контроллер сцены
	init(viewController: SettingsViewControllerProtocol) {
		self.viewController = viewController
	}
}
