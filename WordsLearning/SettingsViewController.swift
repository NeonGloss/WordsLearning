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

	private var statisticsButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.squareGrid, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

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
		view.backgroundColor = UIColor.gray
		setupNavigationBar()

		statisticsButton.addTarget(self, action: #selector(statisticsTapped), for: .touchUpInside)
		view.addSubview(statisticsButton)
	}

	private func setupConstraints() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			statisticsButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
			statisticsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			statisticsButton.heightAnchor.constraint(equalToConstant: 100),
			statisticsButton.widthAnchor.constraint(equalToConstant: 100),
		])
	}

	// MARK: Private

	private func setupNavigationBar() {
		title = "Меню"
		navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedString.Key.foregroundColor: Design.Colors.background0,
			NSAttributedString.Key.font: Design.Fonts.header
		]

		let backItem = UIBarButtonItem(image: SemanticImages.xmark,
										 style: .done,
										 target: self,
										 action: #selector(dissmissScene))

		navigationItem.leftBarButtonItem = backItem
	}

	@objc private func dissmissScene() {
		self.dismiss(animated: true, completion: nil)
	}

	@objc private func statisticsTapped() {
		interactor.statisticsTapped()
	}
}
