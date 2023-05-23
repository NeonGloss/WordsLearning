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

	private lazy var table = DRTableView(settings: DRTableViewSettings())
	private var sortSwitch: UISwitch = {
		let directionSwitch = UISwitch()
		directionSwitch.thumbTintColor = .orange
		directionSwitch.onTintColor = .lightGray
		return directionSwitch
	}()
    
    private let sortTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort by %"
        label.font = label.font.bold()
        return label
    }()

	private let countLabel: UILabel = {
	 let label = UILabel()
	 label.font = label.font.bold()
	 return label
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

	// MARK: - Display

	func displayItems(_ items: [DRTableViewCellProtocol]) {
		table.items = items
		countLabel.text = String(items.count)
	}

	// MARK: - Private

	private func seutpViews() {
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.white
		table.separatorStyle = .singleLine
		sortSwitch.addTarget(self, action: #selector(sortSwitchTapped(_:)), for: .allTouchEvents)
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(sortSwitch)
		view.addSubview(countLabel)
        view.addSubview(sortTypeLabel)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			sortSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),

			countLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			countLabel.centerYAnchor.constraint(equalTo: sortSwitch.centerYAnchor),
            
            sortTypeLabel.leadingAnchor.constraint(equalTo: sortSwitch.leadingAnchor, constant:  -100),
            sortTypeLabel.centerYAnchor.constraint(equalTo: sortSwitch.centerYAnchor),

			table.topAnchor.constraint(equalTo: sortSwitch.bottomAnchor, constant: 5),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	@objc private func dissmissScene() {
		self.dismiss(animated: true, completion: nil)
	}

	@objc private func sortSwitchTapped(_ switcher: UISwitch) {
        sortTypeLabel.text = switcher.isOn ? "Sort by A" : "Sort by %"
		switcher.thumbTintColor = switcher.isOn ? .orange : .orange
		interactor.sortSwitcherChanged(to: switcher.isOn)
	}
}
