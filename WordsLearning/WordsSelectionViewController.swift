//
//  WordsSelectionViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены выбора слов для изучения
protocol WordsSelectionViewControllerProtocol: UIViewController {

	/// Отобразить итемы
	/// - Parameter items: массив итемов
	func displayItems(_ items: [DRTableViewCellProtocol])

	/// Отобразить количество выбранных слов
	/// - Parameter numberOfSelectedWords: количество выбранных слов
	func setSelectedWordCountTo(_ numberOfSelectedWords: Int)

	/// Сбросить выделение для всех слов
	func deselectAllWords()

	/// Закрыть сцену
	func closeScene()
}

/// Вью-контроллер сцены выбора слов для изучения
final class WordsSelectionViewController: UIViewController, WordsSelectionViewControllerProtocol {

	private var interactor: WordsSelectionInteractorProtocol

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

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "Выбери слова 😃"
		label.font = label.font.bold()
		return label
	}()

	private let selectedElementsCounterLabel: UILabel = {
		let label = UILabel()
		label.text = String()
		label.font = label.font.bold()
		return label
	}()

	private var  selectedCounterImageButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.plusCircle.coloredAs(.gray, .gray), for: .normal)
		button.backgroundColor = .clear
		return button
	}()

	private var cleanSelectionButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.xmark.coloredAs(.black, .black), for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitle("   Clear", for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var applyButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.checkmark.coloredAs(.black, .black), for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitle("   Apply", for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameter interactor: интерактор сцены
	init(interactor: WordsSelectionInteractorProtocol) {
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
		interactor.viewWillDisappear()
	}

	// MARK: Display

	func displayItems(_ items: [DRTableViewCellProtocol]) {
		table.items = items
	}

	func setSelectedWordCountTo(_ numberOfSelectedWords: Int) {
		selectedElementsCounterLabel.text = String(numberOfSelectedWords)
		let image = table.items.count == numberOfSelectedWords ? SemanticImages.plusCircle.coloredAs(.gray, .gray) :
		SemanticImages.checkmarkCircle.coloredAs(.white, .orange)

		selectedCounterImageButton.setImage(image, for: .normal)

		if table.items.count == numberOfSelectedWords {
			titleLabel.isHidden = false
			applyButton.isHidden = true
			cleanSelectionButton.isHidden = true
		} else {
			titleLabel.isHidden = true
			applyButton.isHidden = false
			cleanSelectionButton.isHidden = false
		}
	}

	func deselectAllWords() {
		table.items.forEach { tableViewCell in
			guard let cell = tableViewCell as? SelectWordsTableCellProtocol else { return }
			// TODO: при выбранных нескольких словах, и смене сортировки, при нажатии на кнопку очищения - ячейки не очищаются
			cell.displayWordDeselection()
		}
	}

	func closeScene() {
		self.dismiss(animated: true)
	}

	// MARK: Private

	private func seutpViews() {
		cleanSelectionButton.addTarget(self, action: #selector(cleanSelectionButtonTapped), for: .allTouchEvents)
		applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
		sortSwitch.addTarget(self, action: #selector(sortSwitchTapped(_:)), for: .allTouchEvents)
		selectedCounterImageButton.isUserInteractionEnabled = false
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.white
		table.separatorStyle = .singleLine
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(sortSwitch)
		view.addSubview(sortTypeLabel)
		view.addSubview(selectedElementsCounterLabel)
		view.addSubview(selectedCounterImageButton)
		view.addSubview(cleanSelectionButton)
		view.addSubview(applyButton)
		view.addSubview(titleLabel)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([

			cleanSelectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			cleanSelectionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
			cleanSelectionButton.heightAnchor.constraint(equalToConstant: 40),
			cleanSelectionButton.widthAnchor.constraint(equalToConstant: 140),

			applyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			applyButton.topAnchor.constraint(equalTo: cleanSelectionButton.topAnchor),
			applyButton.heightAnchor.constraint(equalTo: cleanSelectionButton.heightAnchor),
			applyButton.widthAnchor.constraint(equalTo: cleanSelectionButton.widthAnchor),

			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: cleanSelectionButton.centerYAnchor),

			sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			sortSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),

			sortTypeLabel.leadingAnchor.constraint(equalTo: sortSwitch.leadingAnchor, constant:  -100),
			sortTypeLabel.centerYAnchor.constraint(equalTo: sortSwitch.centerYAnchor),

			selectedCounterImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
			selectedCounterImageButton.centerYAnchor.constraint(equalTo: sortSwitch.centerYAnchor),
			selectedCounterImageButton.heightAnchor.constraint(equalToConstant: 30),
			selectedCounterImageButton.widthAnchor.constraint(equalToConstant: 30),

			selectedElementsCounterLabel.leadingAnchor.constraint(equalTo: selectedCounterImageButton.trailingAnchor, constant: 15),
			selectedElementsCounterLabel.centerYAnchor.constraint(equalTo: selectedCounterImageButton.centerYAnchor),

			table.topAnchor.constraint(equalTo: sortSwitch.bottomAnchor, constant: 5),
			table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			table.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	// MARK: Private

	@objc private func cleanSelectionButtonTapped() {
		interactor.cleanSelectionButtonTapped()
	}

	@objc private func applyButtonTapped() {
		interactor.applyButtonTapped()
	}

	@objc private func dissmissScene() {
		self.dismiss(animated: true, completion: nil)
		interactor.viewWillDisappear()
	}

	@objc private func sortSwitchTapped(_ switcher: UISwitch) {
		sortTypeLabel.text = switcher.isOn ? "Sort by A" : "Sort by %"
		switcher.thumbTintColor = switcher.isOn ? .orange : .orange
		interactor.sortSwitcherChanged(to: switcher.isOn)
	}
}
