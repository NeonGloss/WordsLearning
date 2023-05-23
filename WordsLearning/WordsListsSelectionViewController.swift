//
//  WordsSelectionViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены выбора слов для изучения
protocol WordsListsSelectionViewControllerProtocol: UIViewController {

	/// Отобразить итемы
	/// - Parameter items: массив итемов
	func displayItems(_ items: [DRTableViewCellProtocol])

	/// Выставить заголовочный текст
	/// - Parameter string: текст
	func setTitleTextTo(_ string: String)

	/// Закрыть сцену
	func closeScene()
}

/// Вью-контроллер сцены выбора слов для изучения
final class WordsListsSelectionViewController: UIViewController, WordsListsSelectionViewControllerProtocol {

	private var interactor: WordsListsSelectionInteractorProtocol
	private var items: [DRTableViewCellProtocol] = []
	private lazy var table = {
		var tableSettings = DRTableViewSettings()
		tableSettings.rowDeletingBySwipeIsEnabled = true
		tableSettings.editBySwipeIsEnabled = true
		return DRTableView(settings: tableSettings)
	}()

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = label.font.bold()
		return label
	}()

	private let createInvitationLabel: UILabel = {
		let label = UILabel()
		label.text = "Можно создать новый 👉"
		label.font = label.font.bold()
		return label
	}()

	private var createButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.plusCircle.coloredAs(.gray, .gray), for: .normal)
		button.layer.borderColor = UIColor.orange.cgColor
		button.backgroundColor = .clear
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var clearButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.xmark.coloredAs(.orange, .black), for: .normal)
		button.setTitle(" Clear", for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameter interactor: интерактор сцены
	init(interactor: WordsListsSelectionInteractorProtocol) {
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

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		if let selectedItemIndex = items.firstIndex(where: { $0.isSelected }) {
			table.scrollToRow(at: IndexPath(row: selectedItemIndex, section: 0), at: .middle, animated: true)
		}
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
	}

	// MARK: - Display

	func displayItems(_ items: [DRTableViewCellProtocol]) {
		table.items = items
		self.items = items
		table.reloadData()
	}

	func setTitleTextTo(_ string: String) {
		titleLabel.text = string
	}

	func closeScene() {
		self.dismiss(animated: true)
	}

	// MARK: - Private

	private func seutpViews() {
		createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
		clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.white
		table.separatorStyle = .singleLine
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(createInvitationLabel)
		view.addSubview(createButton)
		view.addSubview(titleLabel)
		view.addSubview(clearButton)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([

			clearButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
			clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			clearButton.widthAnchor.constraint(equalToConstant: 80),
			clearButton.heightAnchor.constraint(equalToConstant: 25),

			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),

			createInvitationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
			createInvitationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

			createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			createButton.centerYAnchor.constraint(equalTo: createInvitationLabel.centerYAnchor),
			createButton.heightAnchor.constraint(equalToConstant: 40),
			createButton.widthAnchor.constraint(equalToConstant: 40),

			table.topAnchor.constraint(equalTo: createInvitationLabel.bottomAnchor, constant: 30),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	@objc private func createButtonTapped() {
		interactor.createButtonTapped()
	}

	@objc private func clearButtonTapped() {
		interactor.clearButtonTapped()
	}
}
