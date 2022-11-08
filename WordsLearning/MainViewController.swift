//
//  MainViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены
protocol MainViewControllerProtocol: UIViewController {

	/// Отобразить вопрос слова
	/// - Parameters:
	///   - question: слово-ворос
	///   - studyPercent: процент изучения этого слова
	func displayWordQuestion(question: String, remark: String?, studyPercent: String)

	/// Очистить поле ответа
	func cleanAnswerField()
}

/// Вью-контроллер сцены
final class MainViewController: UIViewController, MainViewControllerProtocol {

	private var interactor: MainInteractorProtocol
	private let studyPercentLabel = UILabel()
	private var questionWordLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.cornerRadius = 20
		label.font = UIFont(name: "Thonburi", size: 50)?.bold()
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let wordRemarkLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.cornerRadius = 20
		label.font = UIFont(name: "Thonburi", size: 30)
		label.textAlignment = .center
		return label
	}()

	private var answerWordView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 2
		view.layer.cornerRadius = 20
		return view
	}()

	private var answerWordField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.autocorrectionType = .no
		return textField
	}()

	private var directionSwitch: UISwitch = {
		let directionSwitch = UISwitch()
		directionSwitch.thumbTintColor = .gray
		directionSwitch.onTintColor = .white
		return directionSwitch
	}()

	private var menuButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.squareGrid, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var editButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.sliderHorizontal3, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var markStudiedButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.checkmark, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.backgroundColor = .blue
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var repeatButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.repeatArrows, for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	private var shuffleButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.shuffle, for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = 10
		return button
	}()

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameter interactor: интерактор сцены
	init(interactor: MainInteractorProtocol) {
		self.interactor = interactor
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		seutpView()
		setupLayout()
		interactor.viewDidLoad()
	}

	// MARK: Display

	func displayWordQuestion(question: String, remark: String?, studyPercent: String) {
		if let remark = remark {
			wordRemarkLabel.text = "(" + remark + ")"
		} else {
			wordRemarkLabel.text = nil
		}
		questionWordLabel.text = question
		studyPercentLabel.text = studyPercent
		answerWordField.becomeFirstResponder()
	}

	func cleanAnswerField() {
		answerWordField.text = ""
	}

	// MARK: Private

	private func seutpView() {
		view.overrideUserInterfaceStyle = .light
		answerWordField.backgroundColor = .white
		answerWordField.delegate = self
		view.backgroundColor = .orange
		
		directionSwitch.addTarget(self, action: #selector(directionSwitchTapped(_:)), for: .allTouchEvents)
		markStudiedButton.addTarget(self, action: #selector(markStudiedTapped), for: .touchUpInside)
		shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
		repeatButton.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
		menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
		editButton.addTarget(self, action: #selector(editWordTapped), for: .touchUpInside)
		view.addSubview(questionWordLabel)
		view.addSubview(studyPercentLabel)
		view.addSubview(markStudiedButton)
		view.addSubview(directionSwitch)
		view.addSubview(wordRemarkLabel)
		view.addSubview(answerWordView)
		view.addSubview(shuffleButton)
		view.addSubview(repeatButton)
		view.addSubview(menuButton)
		view.addSubview(editButton)
		view.addSubview(answerWordField)
	}

	@objc private func directionSwitchTapped(_ switcher: UISwitch) {
		switcher.thumbTintColor = switcher.isOn ? .orange : .gray
		interactor.contrverseTranslationSwitcherChanged(to: switcher.isOn)
	}

	@objc private func menuButtonTapped() {
		interactor.menuButtonTapped()
	}

	@objc private func editWordTapped() {
		interactor.editWordTapped()
	}

	@objc private func repeatButtonTapped() {
		repeatButton.backgroundColor = repeatButton.backgroundColor == .clear ? .gray : .clear
		interactor.repeatButtonTapped()
	}

	@objc private func markStudiedTapped() {
		interactor.markStudiedTapped()
	}

	@objc private func shuffleButtonTapped() {
		shuffleButton.backgroundColor = shuffleButton.backgroundColor == .clear ? .gray : .clear
		interactor.shuffleButtonTapped()
	}

	private func setupLayout() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			directionSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
			directionSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

			menuButton.centerYAnchor.constraint(equalTo: directionSwitch.centerYAnchor),
			menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			menuButton.heightAnchor.constraint(equalToConstant: 40),
			menuButton.widthAnchor.constraint(equalToConstant: 40),

			questionWordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
			questionWordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			questionWordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			questionWordLabel.heightAnchor.constraint(equalToConstant: 50),

			wordRemarkLabel.topAnchor.constraint(equalTo: questionWordLabel.bottomAnchor, constant: 5),
			wordRemarkLabel.centerXAnchor.constraint(equalTo: questionWordLabel.centerXAnchor),

			answerWordView.topAnchor.constraint(equalTo: questionWordLabel.bottomAnchor, constant: 100),
			answerWordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			answerWordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			answerWordView.heightAnchor.constraint(equalToConstant: 50),

			studyPercentLabel.bottomAnchor.constraint(equalTo: answerWordView.topAnchor, constant: -10),
			studyPercentLabel.centerXAnchor.constraint(equalTo: answerWordView.centerXAnchor),

			answerWordField.topAnchor.constraint(equalTo: answerWordView.topAnchor, constant: 2),
			answerWordField.bottomAnchor.constraint(equalTo: answerWordView.bottomAnchor, constant: -2),
			answerWordField.leadingAnchor.constraint(equalTo: answerWordView.leadingAnchor, constant: 15),
			answerWordField.trailingAnchor.constraint(equalTo: answerWordView.trailingAnchor, constant: -15),

			markStudiedButton.centerYAnchor.constraint(equalTo: repeatButton.centerYAnchor),
			markStudiedButton.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -15),
			markStudiedButton.heightAnchor.constraint(equalTo: editButton.heightAnchor),
			markStudiedButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),

			editButton.centerYAnchor.constraint(equalTo: repeatButton.centerYAnchor),
			editButton.trailingAnchor.constraint(equalTo: answerWordView.centerXAnchor, constant: -15),
			editButton.heightAnchor.constraint(equalToConstant: 40),
			editButton.widthAnchor.constraint(equalToConstant: 40),

			shuffleButton.centerYAnchor.constraint(equalTo: repeatButton.centerYAnchor),
			shuffleButton.leadingAnchor.constraint(equalTo: answerWordView.centerXAnchor, constant: 15),
			shuffleButton.heightAnchor.constraint(equalTo: editButton.heightAnchor),
			shuffleButton.widthAnchor.constraint(equalTo: editButton.heightAnchor),

			repeatButton.topAnchor.constraint(equalTo: answerWordField.bottomAnchor, constant: 30),
			repeatButton.leadingAnchor.constraint(equalTo: shuffleButton.trailingAnchor, constant: 15),
			repeatButton.heightAnchor.constraint(equalToConstant: 40),
			repeatButton.widthAnchor.constraint(equalToConstant: 40),
		])
	}
}

extension MainViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		interactor.answerReceived(textField.text ?? "")
		return false
	}
}
