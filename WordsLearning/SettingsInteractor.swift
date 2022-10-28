//
//  SettingsInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.09.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

/// Протокол интерактора сцены
protocol SettingsInteractorProtocol {
	
	/// Обновление данных
	func updateData()

	func statisticsTapped()
}

/// Интерактор сцены
final class SettingsInteractor: SettingsInteractorProtocol {

	var presenter: SettingsPresenterProtocol?
	private let router: SettingsRouterProtocol

	private var service: SettingsServiceProtocol

	/// Инициализатор
	/// - Parameters:
	///   - router: роутер
	///   - service: сервис
	///   - analyticsService: сервис отправки аналитики
	init(router: SettingsRouterProtocol,
		 service: SettingsServiceProtocol) {
		self.service = service
		self.router = router
	}

	func updateData() {

	}

	func statisticsTapped() {
		let menuViewController = StatisticsAssembler().create()
		router.openInNavigation(to: menuViewController)
	}
}
