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
    
    /// Отобразить был ли выбран некоторый набор слов для изучения, или изучаются все слова
    /// - Parameter listName: название списка
    func showWordsListName(listName: String?)

	/// Отобразить меню дополнительных функций
	func showCapabilitiesMenu()
}

/// Вью-контроллер сцены
final class MainViewController: UIViewController, MainViewControllerProtocol {

	private var interactor: MainInteractorProtocol
	private var сapabilitiesMenuIsShown = false
	private var capabilitiesMenuView: UIView?
	private let studyPercentLabel = UILabel()
	private let listNameLabel = UILabel()
	private var questionWordLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.cornerRadius = Sizes.buttonWidth / 2
		label.font = UIFont(name: "Thonburi", size: 50)?.bold()
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let wordRemarkLabel: UILabel = {
		let label = UILabel()
		label.layer.borderColor = UIColor.white.cgColor
		label.layer.cornerRadius = Sizes.buttonWidth / 2
		label.font = UIFont(name: "Thonburi", size: 30)
		label.textAlignment = .center
		return label
	}()

	private var answerWordView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 2
		view.layer.cornerRadius = Sizes.buttonWidth / 2
		return view
	}()

	private var answerWordField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = Sizes.buttonWidth / 2
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.textColor = .black
		textField.autocorrectionType = .no
		return textField
	}()

	private var capabilitiesMenuButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.squareGrid, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.backgroundColor = .clear
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = Sizes.buttonWidth / 2
		return button
	}()

	private var editButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.sliderHorizontal3, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = Sizes.buttonWidth / 2
		return button
	}()

	private var markStudiedButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.checkmark, for: .normal)
		button.layer.borderColor = UIColor.white.cgColor
		button.backgroundColor = .blue
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = Sizes.buttonWidth / 2
		return button
	}()

	private var repeatButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.repeatArrows, for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = Sizes.buttonWidth / 2
		return button
	}()

	private var shuffleButton: UIButton = {
		let button = UIButton()
		button.setImage(SemanticImages.shuffle, for: .normal)
		button.backgroundColor = .clear
		button.layer.borderColor = UIColor.white.cgColor
		button.layer.borderWidth = 1.5
		button.layer.cornerRadius = Sizes.buttonWidth / 2
		return button
	}()

	private enum Sizes {
		static let buttonWidth: CGFloat = 40
		static let smallIndent: CGFloat = 15
		static let bigIndent: CGFloat = 30
	}

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
        wordRemarkLabel.text = remark
		questionWordLabel.text = question
		studyPercentLabel.text = studyPercent
		answerWordField.becomeFirstResponder()
	}

	func cleanAnswerField() {
		answerWordField.text = ""
	}
    
	func showWordsListName(listName: String?) {
		let resultText: String
		if let listName = listName {
			resultText = "Слова из списка: \(listName)"
		} else {
			resultText = String()
		}
		listNameLabel.text = resultText
    }

	func showCapabilitiesMenu() {
		capabilitiesMenuButton.isUserInteractionEnabled = false
		if capabilitiesMenuView == nil {
			let viewWidth: CGFloat = view.frame.maxX * 0.6
			let viewHeight: CGFloat = 124
			let originX = view.frame.maxX - viewWidth - 45
			let originY = capabilitiesMenuButton.frame.maxY + 30
			capabilitiesMenuView = ExtraCapabilitiesView(frame: CGRect(x: originX, y: originY, width: viewWidth, height: viewHeight))
			(capabilitiesMenuView as? ExtraCapabilitiesView)?.output = interactor

			capabilitiesMenuView?.alpha = 0
			capabilitiesMenuView?.layer.cornerRadius = 10
			view.addSubview(capabilitiesMenuView ?? UIView())

			UIView.animate(withDuration: 0.5,
						   delay: 0,
						   usingSpringWithDamping: 0.6,
						   initialSpringVelocity: 0.5,
						   animations: {
				self.capabilitiesMenuView?.alpha = 1
				self.capabilitiesMenuView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
			}) { _ in
				self.capabilitiesMenuButton.isUserInteractionEnabled = true
				self.сapabilitiesMenuIsShown = !self.сapabilitiesMenuIsShown
	//			вопрос для собеседования, нужно ли в этом замыкании вик-селф, нужно ли в замыкание диспатч-кью вик-селф?
			}
		} else {
			UIView.animate(withDuration: 0.5,
						   delay: 0,
						   usingSpringWithDamping: 0.6,
						   initialSpringVelocity: 0.5,
						   animations: { self.capabilitiesMenuView?.alpha = 0 }) { _ in
				self.capabilitiesMenuView?.removeFromSuperview()
				self.capabilitiesMenuButton.isUserInteractionEnabled = true
				self.capabilitiesMenuView = nil
			}
		}
	}

	// MARK: Private

	private func seutpView() {
		view.overrideUserInterfaceStyle = .dark
		answerWordField.keyboardAppearance = .dark
		answerWordField.backgroundColor = .white
		answerWordField.delegate = self
		setupBackgroundGradient()

        markStudiedButton.addTarget(self, action: #selector(markStudiedTapped), for: .touchUpInside)
        shuffleButton.addTarget(self, action: #selector(shuffleButtonTapped), for: .touchUpInside)
        repeatButton.addTarget(self, action: #selector(repeatButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editWordTapped), for: .touchUpInside)
		capabilitiesMenuButton.addTarget(self, action: #selector(extraCapabilitiesButtonTapped), for: .touchUpInside)
		view.addSubview(capabilitiesMenuButton)
		view.addSubview(questionWordLabel)
		view.addSubview(studyPercentLabel)
		view.addSubview(markStudiedButton)
		view.addSubview(wordRemarkLabel)
		view.addSubview(answerWordView)
		view.addSubview(listNameLabel)
		view.addSubview(shuffleButton)
		view.addSubview(repeatButton)
		view.addSubview(editButton)
		view.addSubview(answerWordField)
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

	@objc private func extraCapabilitiesButtonTapped() {
	 interactor.extraCapabilitiesButtonTapped()
 }

	private func setupLayout() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		capabilitiesMenuButton.top(to: view.safeAreaLayoutGuide)
		capabilitiesMenuButton.trailingToSuperview().constant = -20
		capabilitiesMenuButton.height(Sizes.buttonWidth)
		capabilitiesMenuButton.width(Sizes.buttonWidth)

		questionWordLabel.topToSuperview().constant = 100
		questionWordLabel.leadingToSuperview().constant = 50
		questionWordLabel.trailingToSuperview().constant = -50
		questionWordLabel.height(50)

		wordRemarkLabel.topToBottom(of: questionWordLabel).constant = 5
		wordRemarkLabel.centerX(to: questionWordLabel)

		answerWordView.topToBottom(of: questionWordLabel).constant = 100
		answerWordView.leadingToSuperview().constant = 50
		answerWordView.trailingToSuperview().constant = -50
		answerWordView.height(50)

		studyPercentLabel.bottomToTop(of: answerWordView).constant = -10
		studyPercentLabel.centerXToSuperview()

		answerWordField.top(to: answerWordView).constant = 2
		answerWordField.bottom(to: answerWordView).constant = -2
		answerWordField.leading(to: answerWordView).constant = Sizes.smallIndent
		answerWordField.trailing(to: answerWordView).constant = -Sizes.smallIndent

		markStudiedButton.topToBottom(of: answerWordView).constant = Sizes.bigIndent
		markStudiedButton.leading(to: answerWordView).constant = Sizes.bigIndent
		markStudiedButton.height(Sizes.buttonWidth)
		markStudiedButton.width(Sizes.buttonWidth)

		editButton.topToBottom(of: answerWordView).constant = Sizes.bigIndent
		editButton.leadingToTrailing(of: markStudiedButton).constant = Sizes.smallIndent
		editButton.height(Sizes.buttonWidth)
		editButton.width(Sizes.buttonWidth)

		repeatButton.topToBottom(of: answerWordView).constant = Sizes.bigIndent
		repeatButton.trailing(to: answerWordView).constant = -Sizes.bigIndent
		repeatButton.height(Sizes.buttonWidth)
		repeatButton.width(Sizes.buttonWidth)

		shuffleButton.topToBottom(of: answerWordView).constant = Sizes.bigIndent
		shuffleButton.trailingToLeading(of: repeatButton).constant = -Sizes.smallIndent
		shuffleButton.height(Sizes.buttonWidth)
		shuffleButton.width(Sizes.buttonWidth)

		listNameLabel.topToBottom(of: repeatButton).constant = 100
		listNameLabel.centerXToSuperview()
	}
}

extension MainViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		interactor.answerReceived(textField.text ?? String())
		return false
	}
}
