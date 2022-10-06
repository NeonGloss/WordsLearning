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
}

/// Интерактор сцены
final class SettingsInteractor: SettingsInteractorProtocol {

	/// Презентер сцены
	var presenter: SettingsPresenterProtocol?

	private var service: SettingsServiceProtocol

	/// Инициализатор
	/// - Parameters:
	///   - router: роутер
	///   - service: сервис
	///   - analyticsService: сервис отправки аналитики
	init(service: SettingsServiceProtocol) {
		self.service = service
	}

	func updateData() {

	}
}
