//
//  StatisticsPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.10.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

/// Протокол презентера сцены
protocol StatisticsPresenterProtocol {

	/// Отобразить элементы таблицы
	/// - Parameter items: элементы таблицы
	func presentItems(_ items: [DRTableViewCellProtocol])
}

/// Презентер сцены
final class StatisticsPresenter: StatisticsPresenterProtocol {

	private weak var viewController: StatisticsViewControllerProtocol?

	/// Инициализатор
	/// - Parameter viewController: вью-контроллер сцены
	init(viewController: StatisticsViewControllerProtocol) {
		self.viewController = viewController
	}

	func presentItems(_ items: [DRTableViewCellProtocol]) {
		viewController?.displayItems(items)
	}
}
