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
        directionSwitch.layer.borderWidth = 1
        directionSwitch.layer.cornerRadius = 15
        directionSwitch.thumbTintColor = .orange
        directionSwitch.onTintColor = .systemMint
        directionSwitch.layer.borderColor = UIColor.white.cgColor
		return directionSwitch
	}()

	private let closeButton: CustomUIButton = {
		var configuration = UIButton.Configuration.filled()
		configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
		let button = CustomUIButton(configuration: configuration)
		button.setImage(SemanticImages.leftChevron, for: .normal)
        button.layer.borderWidth = 1.5
		button.layer.borderColor = UIColor.white.cgColor
		button.tintColor = Design.Colors.dsNuance0
		button.layer.cornerRadius = 20
		return button
	}()
    
    private let sortTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Sort by %"
        label.font = label.font.bold()
        label.textColor = .white
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
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
        countLabel.text = String(items.count) + " words"
        table.items = items
	}

	// MARK: - Private

	private func seutpViews() {
        setupBackgroundGradient()

		table.separatorStyle = .singleLine
		sortSwitch.addTarget(self, action: #selector(sortSwitchTapped(_:)), for: .allTouchEvents)
		closeButton.addTarget(self, action: #selector(dissmissScene), for: .touchUpInside)
	}

    private func setupBackgroundGradient() {
        let topColor = Design.Colors.gradientBackground0Top.cgColor
        let bottomColor = Design.Colors.gradientBackground0Bottom.cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(sortSwitch)
		view.addSubview(countLabel)
		view.addSubview(closeButton)
        view.addSubview(sortTypeLabel)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }


        NSLayoutConstraint.activate([
            sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            sortSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),


            sortTypeLabel.leadingAnchor.constraint(equalTo: sortSwitch.leadingAnchor, constant:  -100),
            sortTypeLabel.centerYAnchor.constraint(equalTo: sortSwitch.centerYAnchor),

            table.topAnchor.constraint(equalTo: sortSwitch.bottomAnchor, constant: 5),
            table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        closeButton.top(to: view.safeAreaLayoutGuide)
        closeButton.leadingToSuperview().constant = 20
        closeButton.height(40)
        closeButton.width(40)

        countLabel.centerXToSuperview()
        countLabel.centerY(to: closeButton)
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
