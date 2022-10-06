//
//  RootViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//

import UIKit

/// Класс root контроллера
final class RootViewController: UIViewController {

	/// Синглтон root контроллера
	public static let shared = RootViewController()

	private let durationValue = 0.3
	private var currentVC: UIViewController

	private init() {
		let navigationController = UINavigationController()
		self.currentVC = MainAssembler().createMainScene(with: navigationController) 
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		addChild(currentVC)
		currentVC.view.frame = view.bounds
		view.addSubview(currentVC.view)
		currentVC.didMove(toParent: self)
	}

	/// Смена root контроллера
	/// - Parameters:
	///   - newController: новый контроллер
	///   - completion: замыкание
	func shiftRootVCto(_ newController: UIViewController, completion: (() -> Void)? = nil) {
		currentVC.willMove(toParent: nil)
		addChild(newController)

		transition(from: currentVC,
				   to: newController,
				   duration: durationValue,
				   options: [.transitionCrossDissolve, .curveEaseOut],
				   animations: {
		}) { _ in
			self.currentVC.removeFromParent()
			newController.didMove(toParent: self)
			self.currentVC = newController
			completion?()
		}
	}

	/// Смена root контроллера на контроллер в сцене с таббаром
	func switchToMainScreen() {
//		shiftRootVCto(MainTabBarController())
	}

	/// Переход на сцену после активации диплинка
	/// - Parameter destination: сцена
	/// - Parameter url: диплинк
	/// - Returns: true, если успешный переход
//	func routTo(_ destination: DeeplinkDestination, url: URL) -> Bool {
//		if type(of: currentVC) == MainTabBarController.self,
//			let tabBarController = currentVC as? MainTabBarController {
//			switch destination {
//			case .test:
//				tabBarController.selectedIndex = StandType.ift.rawValue
//				AppDelegate.authService?.handle(open: url)
//			case .partners:
//				tabBarController.selectedIndex = StandType.psi.rawValue
//			case .partnerApps:
//				tabBarController.selectedIndex = StandType.prom.rawValue
//			case .backRedirect:
//				let redirectVC = RedirectViewController(url: url, loaderType: .activityIndicator)
//				present(redirectVC, animated: true, completion: nil)
//			case .domclick:
//				if url.path == resultUrlPath {
//					tabBarController.selectedIndex = StandType.ift.rawValue
//					AppDelegate.authService?.handle(open: url)
//				} else if url.path == mainUrlPath {
//					let appRedirectVC = ((tabBarController.viewControllers?[3]
//											as? UINavigationController)?.viewControllers.first)
//											as? AppRedirectViewController
//					appRedirectVC?.responseReceived(url: url)
//				} else {
//					let redirectVC = RedirectViewController(url: url, loaderType: .domclickImage)
//					present(redirectVC, animated: true, completion: nil)
//				}
//			case .app2appRedirect:
//				tabBarController.selectedIndex = 3
//			}
//			mainTabBarSelectedIndex = tabBarController.selectedIndex
//			return true
//		}
//		return false
//	}

	/// Вывод алерта о ненайденной схеме (сцене) в приложении
	func schemeNotFoundAlert() {
//		self.present(Alert().alertAction(style: .unrecognizedScheme), animated: true)
	}

//	required init?(coder aDecoder: NSCoder) {
//		fatalError(UIConstTextValues.fatalError)
//	}
}

