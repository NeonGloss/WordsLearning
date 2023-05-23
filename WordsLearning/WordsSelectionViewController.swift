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

	/// Выставить название списка
	/// - Parameter name: название
	func setNameTo(_ name: String?)

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

	private var dismissButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.xmark.coloredAs(.orange, .black), for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
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

	private var saveButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.checkmark.coloredAs(.black, .black), for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.setTitle("   Save", for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.orange.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var nameFieldView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20
		return view
	}()

	private var nameField: UITextField = {
		let textField = UITextField()
		textField.placeholder = "Введите азвание списка"
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.autocorrectionType = .no
		return textField
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

	// MARK: - Display

	func displayItems(_ items: [DRTableViewCellProtocol]) {
		table.items = items
	}

	func setNameTo(_ name: String?) {
		nameField.text = name
	}

	func setSelectedWordCountTo(_ numberOfSelectedWords: Int) {
		selectedElementsCounterLabel.text = String(numberOfSelectedWords)
		let image = numberOfSelectedWords == 0 ? SemanticImages.plusCircle.coloredAs(.gray, .gray) :
												 SemanticImages.checkmarkCircle.coloredAs(.white, .orange)

		selectedCounterImageButton.setImage(image, for: .normal)

		if table.items.count == numberOfSelectedWords {
			titleLabel.isHidden = false
			saveButton.isHidden = true
			cleanSelectionButton.isHidden = true
		} else {
			titleLabel.isHidden = true
			saveButton.isHidden = false
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

	// MARK: - Private

	private func seutpViews() {
		cleanSelectionButton.addTarget(self, action: #selector(cancelButtonTapped), for: .allTouchEvents)
		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		sortSwitch.addTarget(self, action: #selector(sortSwitchTapped(_:)), for: .allTouchEvents)
		dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
		selectedCounterImageButton.isUserInteractionEnabled = false
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.white
		table.separatorStyle = .singleLine

		nameField.delegate = self
	}

	private func setupConstraints() {
		view.addSubview(table)
		view.addSubview(sortSwitch)
		view.addSubview(sortTypeLabel)
		view.addSubview(selectedElementsCounterLabel)
		view.addSubview(selectedCounterImageButton)
		view.addSubview(cleanSelectionButton)
		view.addSubview(nameFieldView)
		view.addSubview(dismissButton)
		view.addSubview(saveButton)
		view.addSubview(titleLabel)
		view.addSubview(nameField)
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([

			dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
			dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
			dismissButton.widthAnchor.constraint(equalToConstant: 25),
			dismissButton.heightAnchor.constraint(equalToConstant: 25),

			nameFieldView.heightAnchor.constraint(equalToConstant: 40),
			nameFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nameFieldView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
			nameFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),

			nameField.topAnchor.constraint(equalTo: nameFieldView.topAnchor, constant: 2),
			nameField.bottomAnchor.constraint(equalTo: nameFieldView.bottomAnchor, constant: -2),
			nameField.leadingAnchor.constraint(equalTo: nameFieldView.leadingAnchor, constant: 15),
			nameField.trailingAnchor.constraint(equalTo: nameFieldView.trailingAnchor, constant: -15),

			cleanSelectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			cleanSelectionButton.topAnchor.constraint(equalTo: nameFieldView.bottomAnchor, constant: 10),
			cleanSelectionButton.heightAnchor.constraint(equalToConstant: 40),
			cleanSelectionButton.widthAnchor.constraint(equalToConstant: 140),

			saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			saveButton.topAnchor.constraint(equalTo: cleanSelectionButton.topAnchor),
			saveButton.heightAnchor.constraint(equalTo: cleanSelectionButton.heightAnchor),
			saveButton.widthAnchor.constraint(equalTo: cleanSelectionButton.widthAnchor),

			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			titleLabel.centerYAnchor.constraint(equalTo: cleanSelectionButton.centerYAnchor),

			sortSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
			sortSwitch.topAnchor.constraint(equalTo: cleanSelectionButton.topAnchor, constant: 50),

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

	@objc private func cancelButtonTapped() {
		interactor.cleanSelectionButtonTapped()
	}

	@objc private func saveButtonTapped() {
		interactor.saveButtonTapped()
	}

	@objc private func dissmissScene() {
		self.dismiss(animated: true, completion: nil)
		interactor.viewWillDisappear()
	}

	@objc private func dismissButtonTapped() {
		self.dismiss(animated: true, completion: nil)
		interactor.dismissButtonTapped()
	}

	@objc private func sortSwitchTapped(_ switcher: UISwitch) {
		sortTypeLabel.text = switcher.isOn ? "Sort by A" : "Sort by %"
		switcher.thumbTintColor = switcher.isOn ? .orange : .orange
		interactor.sortSwitcherChanged(to: switcher.isOn)
	}
}

extension WordsSelectionViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textChanged(in: textField)
		return false
	}

	func textFieldDidChangeSelection(_ textField: UITextField) {
		textChanged(in: textField)
	}

	// MARK: Private

	private func textChanged(in textField: UITextField) {
		let newText = textField.text ?? ""
		interactor.listNameChanged(to: newText)
	}
}

