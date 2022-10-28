//
//  StatisticsRouter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.10.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол роутера сцены
protocol StatisticsRouterProtocol {
	
}

/// Роутер сцены
final class StatisticsRouter: StatisticsRouterProtocol {

	private weak var navigationController: UINavigationController?

	/// Инициализатор
	///
	/// - Parameters:
	///   - navigationController: навигейшн контроллер
	init(navigationController: UINavigationController?) {
		self.navigationController = navigationController
	}
}
