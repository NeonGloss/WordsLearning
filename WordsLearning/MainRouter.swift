//
//  MainRouter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол роутера сцены
protocol MainRouterProtocol {
	
	func routeModallyTo(_ viewController: UIViewController)

	func routeTo(_ viewControllerToPresent: UIViewController)
}

/// Роутер сцены
final class MainRouter: MainRouterProtocol {

	weak var viewController: UIViewController?

	func routeModallyTo(_ viewControllerToPresent: UIViewController) {
		viewController?.present(viewControllerToPresent, animated: true)
	}

	func routeTo(_ viewControllerToPresent: UIViewController) {
		viewControllerToPresent.modalPresentationStyle = .fullScreen
		viewController?.present(viewControllerToPresent, animated: true)
	}
}
