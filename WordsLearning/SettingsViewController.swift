//
//  SettingsViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.09.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены
protocol SettingsViewControllerProtocol: AnyObject {
	
}

/// Вью-контроллер сцены
final class SettingsViewController: UIViewController,
											  SettingsViewControllerProtocol {

	private var interactor: SettingsInteractorProtocol

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameter interactor: интерактор сцены
	init(interactor: SettingsInteractorProtocol) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		seutpViews()
		setupConstraints()
		interactor.updateData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	// MARK: Display

	// MARK: Private

	private func seutpViews() {
		view.backgroundColor = UIColor.orange
	}

	private func setupConstraints() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
		])
	}
}
