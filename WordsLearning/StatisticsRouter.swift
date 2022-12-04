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
    
    func routeModallyTo(_ viewController: UIViewController)
	
}

/// Роутер сцены
final class StatisticsRouter: StatisticsRouterProtocol {

    private weak var viewController: UIViewController?

	/// Инициализатор
	/// - Parameters:
	///   - viewController: текущий view controller
	init(viewController: UIViewController?) {
		self.viewController = viewController
	}
    
    func routeModallyTo(_ viewControllerToPresent: UIViewController) {
        viewController?.present(viewControllerToPresent, animated: true)
    }
}
