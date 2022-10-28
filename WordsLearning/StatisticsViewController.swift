//
//  StatisticsViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.10.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены
protocol StatisticsViewControllerProtocol: AnyObject {

	/// Отобразить итемы
	/// - Parameter items: массив итемов
	func displayItems(_ items: [DRTableViewCellProtocol])
}

/// Вью-контроллер сцены
final class StatisticsViewController: UIViewController, StatisticsViewControllerProtocol {

	private var interactor: StatisticsInteractorProtocol

	private lazy var table = DRTableView(frame: .zero)
	private var directionSwitch: UISwitch = {
		let directionSwitch = UISwitch()
		directionSwitch.thumbTintColor = .gray
		directionSwitch.onTintColor = .white
		return directionSwitch
	}()

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameter interactor: интерактор сцены
	init(interactor: StatisticsInteractorProtocol) {
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
		interactor.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	// MARK: Display

	func displayItems(_ items: [DRTableViewCellProtocol]) {
		table.items = items
	}

	// MARK: Private

	private func seutpViews() {
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.white
		table.separatorStyle = .singleLine
		directionSwitch.addTarget(self, action: #selector(directionSwitchTapped(_:)), for: .allTouchEvents)
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(directionSwitch)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			directionSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			directionSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),

			table.topAnchor.constraint(equalTo: directionSwitch.bottomAnchor, constant: 5),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	// MARK: Private

	@objc private func dissmissScene() {
		self.dismiss(animated: true, completion: nil)
	}

	@objc private func directionSwitchTapped(_ switcher: UISwitch) {
		switcher.thumbTintColor = switcher.isOn ? .orange : .gray
		interactor.translationSwitcherChanged(to: switcher.isOn)
	}
}
