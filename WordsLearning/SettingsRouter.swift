//
//  SettingsRouter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.09.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол роутера сцены
protocol SettingsRouterProtocol {

	func openInNavigation(to viewControllerToPresent: UIViewController)
}

/// Роутер сцены
final class SettingsRouter: NSObject, SettingsRouterProtocol {

	weak var viewController: UIViewController?

	func openInNavigation(to viewControllerToPresent: UIViewController) {
		viewController?.navigationController?.pushViewController(viewControllerToPresent, animated: true)
	}
}
