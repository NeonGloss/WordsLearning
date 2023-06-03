//
//  WordEditionViewController.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

/// Протокол вью-контроллера сцены изменения свойств слова
protocol WordEditionViewControllerProtocol: UIViewController {

	func fillWith(foreign: String,
				  native: String,
				  fToNRemark: String?,
				  nToFRemark: String?,
				  transctription: String)
}

/// Вью-контроллер сцены изменения свойств слова
final class WordEditionViewController: UIViewController, WordEditionViewControllerProtocol {

	private var interactor: WordEditionInteractorProtocol

	private lazy var nativeFormLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.numberOfLines = 2
		label.text = SemanticStrings.nativeForm
		label.layer.cornerRadius = 15
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 15)?.bold()
		label.textAlignment = .center
		return label
	}()

	private lazy var foreignFormLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.text = SemanticStrings.foreignForm
		label.numberOfLines = 0
		label.textAlignment = .center
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 15)?.bold()
		return label
	}()

	private lazy var transcriptionLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.text = SemanticStrings.transcription
		label.numberOfLines = 0
		label.textAlignment = .center
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 15)?.bold()
		return label
	}()

	private lazy var fToNRemarkLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.text = SemanticStrings.remark
		label.numberOfLines = 0
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 15)?.bold()
		return label
	}()

	private lazy var nToFRemarkLabel: UILabel = {
		let label = UILabel()
		label.sizeToFit()
		label.text = SemanticStrings.remark
		label.numberOfLines = 0
		label.textAlignment = .center
		label.layer.cornerRadius = 20
		label.layer.borderColor = UIColor.white.cgColor
		label.font = UIFont(name: "Thonburi", size: 15)?.bold()
		return label
	}()

	private var nativeFormView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20
		return view
	}()

	private var nativeFormField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.autocorrectionType = .no
		return textField
	}()

	private var foreignFormView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20
		return view
	}()

	private var foreignFormField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.autocorrectionType = .no
		return textField
	}()

	private var fToNRemarkUnderFieldView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20 * 0.75
		return view
	}()

	private var nToFRemarkUnderFieldView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20 * 0.75
		return view
	}()

	private var fToNRemarkField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 18)
		textField.autocorrectionType = .no
		return textField
	}()

	private var nToFRemarkField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 18)
		textField.autocorrectionType = .no
		return textField
	}()

	private var transcriptionView: UIView = {
		let view = UIView()
		view.backgroundColor = .white
		view.layer.borderColor = UIColor.black.cgColor
		view.layer.borderWidth = 1
		view.layer.cornerRadius = 20
		return view
	}()

	private var transcriptionField: UITextField = {
		let textField = UITextField()
		textField.autocapitalizationType = .none
		textField.layer.cornerRadius = 20
		textField.font = UIFont(name: "Thonburi", size: 25)?.bold()
		textField.autocorrectionType = .no
		return textField
	}()

	private var saveButton: KeyboardRespondableUIButton = {
		let button = KeyboardRespondableUIButton()
		button.backgroundColor = .white
		button.layer.borderColor = UIColor.black.cgColor
		button.setTitle(SemanticStrings.save, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 18
		return button
	}()

	private var cancelButton: KeyboardRespondableUIButton = {
		let button = KeyboardRespondableUIButton()
		button.backgroundColor = .white
		button.layer.borderColor = UIColor.black.cgColor
		button.setTitle(SemanticStrings.cancel, for: .normal)
		button.setTitleColor(.black, for: .normal)
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 18
		return button
	}()

	private enum Sizes {
		static let contentWidthMultiplier: CGFloat = 0.9
		static let buttonsWidthMulitplier: CGFloat = 0.4
		static let foreignLabelToTop: CGFloat = 15
		static let labelToField: CGFloat = 10
		static let leftIndent: CGFloat = 10
		static let rightIndent: CGFloat = 10
		static let buttonsToBottom: CGFloat = 30
		static let verticalIndent: CGFloat = 30
		static let remarkLabelToField: CGFloat = 10
		static let smallVerticalIndent: CGFloat = 30
		static let horizontalIndent: CGFloat = 15
		static let formHeight: CGFloat = 40
	}

	// MARK: Object lifecycle

	/// Инициализатор
	/// - Parameters:
	///  - interactor: интерактор
	init(interactor: WordEditionInteractorProtocol) {
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

	// MARK: Display

	func fillWith(foreign: String,
				  native: String,
				  fToNRemark: String?,
				  nToFRemark: String?,
				  transctription: String) {
		nativeFormField.text = native
		foreignFormField.text = foreign
		fToNRemarkField.text = fToNRemark
		nToFRemarkField.text = nToFRemark
		transcriptionField.text = transctription
	}

	// MARK: Private

	private func seutpViews() {
		view.overrideUserInterfaceStyle = .light
		view.backgroundColor = UIColor.darkGray
		view.addSubview(fToNRemarkUnderFieldView)
		view.addSubview(nToFRemarkUnderFieldView)
		view.addSubview(nativeFormView)
		view.addSubview(foreignFormView)
		view.addSubview(transcriptionView)
		view.addSubview(nativeFormLabel)
		view.addSubview(foreignFormLabel)
		view.addSubview(transcriptionLabel)
		view.addSubview(nToFRemarkLabel)
		view.addSubview(fToNRemarkLabel)
		view.addSubview(fToNRemarkField)
		view.addSubview(nToFRemarkField)
		view.addSubview(nativeFormField)

		view.addSubview(foreignFormField)
		view.addSubview(transcriptionField)
		view.addSubview(saveButton)
		view.addSubview(cancelButton)


		transcriptionField.delegate = self
		foreignFormField.delegate = self
		nativeFormField.delegate = self
		fToNRemarkField.delegate = self
		nToFRemarkField.delegate = self

		saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
		cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
	}

	private func setupConstraints() {
		view.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		NSLayoutConstraint.activate([
			foreignFormLabel.heightAnchor.constraint(equalToConstant: 30),
			foreignFormLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			foreignFormLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizes.foreignLabelToTop),
			foreignFormLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			foreignFormView.heightAnchor.constraint(equalToConstant: Sizes.formHeight),
			foreignFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			foreignFormView.topAnchor.constraint(equalTo: foreignFormLabel.bottomAnchor, constant: Sizes.labelToField),
			foreignFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			foreignFormField.topAnchor.constraint(equalTo: foreignFormView.topAnchor, constant: 2),
			foreignFormField.bottomAnchor.constraint(equalTo: foreignFormView.bottomAnchor, constant: -2),
			foreignFormField.leadingAnchor.constraint(equalTo: foreignFormView.leadingAnchor, constant: Sizes.horizontalIndent),
			foreignFormField.trailingAnchor.constraint(equalTo: foreignFormView.trailingAnchor, constant: -Sizes.horizontalIndent),

			fToNRemarkUnderFieldView.topAnchor.constraint(equalTo: foreignFormField.bottomAnchor, constant: 5),
			fToNRemarkUnderFieldView.leadingAnchor.constraint(equalTo: fToNRemarkLabel.trailingAnchor, constant: Sizes.remarkLabelToField),
			fToNRemarkUnderFieldView.trailingAnchor.constraint(equalTo: foreignFormView.trailingAnchor),
			fToNRemarkUnderFieldView.heightAnchor.constraint(equalToConstant: Sizes.formHeight*0.75),

			fToNRemarkField.topAnchor.constraint(equalTo: fToNRemarkUnderFieldView.topAnchor, constant: 2),
			fToNRemarkField.bottomAnchor.constraint(equalTo: fToNRemarkUnderFieldView.bottomAnchor, constant: -2),
			fToNRemarkField.leadingAnchor.constraint(equalTo: fToNRemarkUnderFieldView.leadingAnchor, constant: Sizes.horizontalIndent),
			fToNRemarkField.trailingAnchor.constraint(equalTo: fToNRemarkUnderFieldView.trailingAnchor, constant: -Sizes.horizontalIndent),

			fToNRemarkLabel.centerYAnchor.constraint(equalTo: fToNRemarkUnderFieldView.centerYAnchor),
			fToNRemarkLabel.leadingAnchor.constraint(equalTo: foreignFormView.leadingAnchor, constant: Sizes.horizontalIndent),
			fToNRemarkLabel.widthAnchor.constraint(equalToConstant: 70),

			nativeFormLabel.heightAnchor.constraint(equalToConstant: 30),
			nativeFormLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nativeFormLabel.topAnchor.constraint(equalTo: fToNRemarkUnderFieldView.bottomAnchor, constant: Sizes.verticalIndent/2),
			nativeFormLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			nativeFormView.heightAnchor.constraint(equalToConstant: Sizes.formHeight),
			nativeFormView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nativeFormView.topAnchor.constraint(equalTo: nativeFormLabel.bottomAnchor, constant: Sizes.labelToField),
			nativeFormView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			nativeFormField.topAnchor.constraint(equalTo: nativeFormView.topAnchor, constant: 2),
			nativeFormField.bottomAnchor.constraint(equalTo: nativeFormView.bottomAnchor, constant: -2),
			nativeFormField.leadingAnchor.constraint(equalTo: nativeFormView.leadingAnchor, constant: Sizes.horizontalIndent),
			nativeFormField.trailingAnchor.constraint(equalTo: nativeFormView.trailingAnchor, constant: -Sizes.horizontalIndent),

			nToFRemarkUnderFieldView.topAnchor.constraint(equalTo: nativeFormField.bottomAnchor, constant: 5),
			nToFRemarkUnderFieldView.leadingAnchor.constraint(equalTo: nToFRemarkLabel.trailingAnchor, constant: Sizes.remarkLabelToField),
			nToFRemarkUnderFieldView.trailingAnchor.constraint(equalTo: nativeFormView.trailingAnchor),
			nToFRemarkUnderFieldView.heightAnchor.constraint(equalToConstant: Sizes.formHeight*0.75),

			nToFRemarkField.topAnchor.constraint(equalTo: nToFRemarkUnderFieldView.topAnchor, constant: 2),
			nToFRemarkField.bottomAnchor.constraint(equalTo: nToFRemarkUnderFieldView.bottomAnchor, constant: -2),
			nToFRemarkField.leadingAnchor.constraint(equalTo: nToFRemarkUnderFieldView.leadingAnchor, constant: Sizes.horizontalIndent),
			nToFRemarkField.trailingAnchor.constraint(equalTo: nToFRemarkUnderFieldView.trailingAnchor, constant: -Sizes.horizontalIndent),

			nToFRemarkLabel.centerYAnchor.constraint(equalTo: nToFRemarkUnderFieldView.centerYAnchor),
			nToFRemarkLabel.leadingAnchor.constraint(equalTo: nativeFormView.leadingAnchor, constant: Sizes.horizontalIndent),
			nToFRemarkLabel.widthAnchor.constraint(equalToConstant: 70),

			transcriptionLabel.heightAnchor.constraint(equalToConstant: 30),
			transcriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			transcriptionLabel.topAnchor.constraint(equalTo: nToFRemarkUnderFieldView.bottomAnchor, constant: Sizes.verticalIndent/2),
			transcriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			transcriptionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			transcriptionView.heightAnchor.constraint(equalToConstant: Sizes.formHeight),
			transcriptionView.topAnchor.constraint(equalTo: transcriptionLabel.bottomAnchor, constant: Sizes.labelToField),
			transcriptionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.contentWidthMultiplier),

			transcriptionField.topAnchor.constraint(equalTo: transcriptionView.topAnchor, constant: 2),
			transcriptionField.bottomAnchor.constraint(equalTo: transcriptionView.bottomAnchor, constant: -2),
			transcriptionField.leadingAnchor.constraint(equalTo: transcriptionView.leadingAnchor, constant: 15),
			transcriptionField.trailingAnchor.constraint(equalTo: transcriptionView.trailingAnchor, constant: -15),

			cancelButton.leadingAnchor.constraint(equalTo: transcriptionView.leadingAnchor),
			cancelButton.topAnchor.constraint(equalTo: transcriptionView.bottomAnchor, constant: Sizes.verticalIndent),
			cancelButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.buttonsWidthMulitplier),
			cancelButton.heightAnchor.constraint(equalToConstant: Sizes.formHeight),

			saveButton.trailingAnchor.constraint(equalTo: transcriptionView.trailingAnchor),
			saveButton.topAnchor.constraint(equalTo: transcriptionView.bottomAnchor, constant: Sizes.verticalIndent),
			saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Sizes.buttonsWidthMulitplier),
			saveButton.heightAnchor.constraint(equalToConstant: Sizes.formHeight),
		])
	}

	@objc private func saveButtonTapped() {
		interactor.saveButtonTapped()
	}

	@objc private func cancelButtonTapped() {
		dismiss(animated: true)
	}
}

extension WordEditionViewController: UITextFieldDelegate {

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
		switch textField {
		case transcriptionField:
			interactor.transcriptionChanged(to: newText)
		case foreignFormField:
			interactor.foreignChanged(to: newText)
		case nativeFormField:
			interactor.nativeChanged(to: newText)
		case fToNRemarkField:
			interactor.fToNRemarkChanged(to: textField.text)
		case nToFRemarkField:
			interactor.nToFRemarkChanged(to: textField.text)
		default: break
		}
	}
}
