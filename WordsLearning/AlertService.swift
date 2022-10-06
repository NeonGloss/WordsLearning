//
//  AlertService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 02.08.2022.
//

import UIKit

protocol AlertServiceProtocol {

	func showSimpleAlert(over viewController: UIViewController,
						 title: String,
						 message: String,
						 completion: (() -> Void)?)

	func showRichAlert(over viewController: UIViewController,
					   image: UIImage?,
					   title: String?,
					   subtitle: String,
					   buttonsSettings: [ButtonSettins])
}

final class AlertService: AlertServiceProtocol {

	func showSimpleAlert(over viewController: UIViewController,
						 title: String,
						 message: String,
						 completion: (() -> Void)?) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
			if let completion = completion {
				completion()
			}
		})
		viewController.present(alert, animated: true)
	}

	func showRichAlert(over viewController: UIViewController,
					   image: UIImage?,
					   title: String?,
					   subtitle: String,
					   buttonsSettings: [ButtonSettins]) {
		let richAlert = RichAlertViewController(image: image, title: title, subtitle: subtitle, buttons: buttonsSettings)
		richAlert.modalPresentationStyle = .overCurrentContext
		viewController.present(richAlert, animated: false)
	}
}
