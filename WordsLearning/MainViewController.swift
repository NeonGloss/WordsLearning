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

	func displayWordQuestion(question: String)

	func cleanAnswerField()
}

/// Вью-контроллер сцены
final class MainViewController: UIViewController, MainViewControllerProtocol {

	private var interactor: MainInteractorProtocol
	private var questionWordLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.cornerRadius = 20
		label.font = UIFont(name: "Thonburi", size: 50)?.bold()
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
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

	private lazy var editImage: UIImageView = {
		let imageView = UIImageView()
		imageView.image = SemanticImages.editionPen
		return imageView
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

	func displayWordQuestion(question: String) {
		questionWordLabel.text = question
		answerWordField.becomeFirstResponder()
	}

	func cleanAnswerField() {
		answerWordField.text = ""
	}

	// MARK: Private

	private func seutpView() {
		directionSwitch.addTarget(self, action: #selector(directionSwitchTapped(_:)), for: .allTouchEvents)
		let tapGest = UITapGestureRecognizer(target: self, action: #selector(editWordTapped))
		editImage.addGestureRecognizer(tapGest)
		editImage.isUserInteractionEnabled = true
		view.overrideUserInterfaceStyle = .light
		view.addSubview(questionWordLabel)
		view.addSubview(directionSwitch)
		view.addSubview(answerWordView)
		view.addSubview(answerWordField)
		view.addSubview(editImage)
		answerWordField.delegate = self
		answerWordField.backgroundColor = .white
		view.backgroundColor = .orange
	}

	@objc private func directionSwitchTapped(_ switcher: UISwitch) {
		switcher.thumbTintColor = switcher.isOn ? .orange : .gray
		interactor.contrverseTranslationSwitcherChanged(to: switcher.isOn)
	}

	@objc private func editWordTapped() {
		interactor.editWordTapped()
	}

	private func setupLayout() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			directionSwitch.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
			directionSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

			questionWordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
			questionWordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			questionWordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			questionWordLabel.heightAnchor.constraint(equalToConstant: 50),

			answerWordView.topAnchor.constraint(equalTo: questionWordLabel.bottomAnchor, constant: 100),
			answerWordView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			answerWordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			answerWordView.heightAnchor.constraint(equalToConstant: 50),

			answerWordField.topAnchor.constraint(equalTo: answerWordView.topAnchor, constant: 2),
			answerWordField.bottomAnchor.constraint(equalTo: answerWordView.bottomAnchor, constant: -2),
			answerWordField.leadingAnchor.constraint(equalTo: answerWordView.leadingAnchor, constant: 15),
			answerWordField.trailingAnchor.constraint(equalTo: answerWordView.trailingAnchor, constant: -15),

			editImage.topAnchor.constraint(equalTo: answerWordField.bottomAnchor, constant: 30),
			editImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			editImage.heightAnchor.constraint(equalToConstant: 30),
			editImage.widthAnchor.constraint(equalToConstant: 30)
		])
	}
}

extension MainViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		interactor.answerReceived(textField.text ?? "")
		return false
	}
}
