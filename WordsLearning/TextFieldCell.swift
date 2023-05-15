//
//  TextFieldCell.swift
//  DailyResults
//
//  Created by Roman Kuzin on 19.07.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

protocol TextFieldCellOutputProtocol: AnyObject {

	/// Изменился текст в ячейке
	/// - Parameters:
	///   - newValue: новое значение текста
	///   - forTag: тег, указывает, какая именно ячейка была изменена
	func textChangedTo(newValue: String?, forTag: String)
}

/// Ячейка с полем для ввода текста
final class TextFieldCell: UITableViewCell, DRTableViewCellProtocol {

	private let output: TextFieldCellOutputProtocol?

	/// Тег изменяемого текста
	private var editionAimTag: String
	private var placeHolderText: String
	private let titleLabel = UILabel()
	private let textField = UITextField()
	private let underlineView = UIView()

	// MARK: DRTableViewCellProtocol

	let shouldReuse = false

	// MARK: life cycle

	init(title: String? = nil,
		 text: String? = nil,
		 placeholder: String?,
		 tag: String,
		 output: TextFieldCellOutputProtocol?) {
		self.output = output
		titleLabel.text = title
		editionAimTag = tag
		placeHolderText = placeholder ??  String()
		if let text = text, !text.isEmpty {
			textField.text = text
		}

		super.init(style: .subtitle, reuseIdentifier: nil)
		selectionStyle = .none

		textField.delegate = self
		setupUI()
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func didSelected() {}

	func someCellWasSelected() {
		finishEnteringText()
	}

	func emptySpaceOnTableWasTapped() {
		finishEnteringText()
	}
    
    func selectedToBeRemoved(complition: @escaping (Bool) -> ()) {
        complition(false)
    }

	public func makeFirstResponder() {
		textField.becomeFirstResponder()
	}

	public func finishEnteringText() {
		endEditing(true)
	}

	// MARK: Private

	private func setupConstraints() {
		contentView.addSubview(textField)
		contentView.addSubview(titleLabel)
		contentView.addSubview(underlineView)
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }

		if titleLabel.text == nil {
			NSLayoutConstraint.activate([
				titleLabel.heightAnchor.constraint(equalToConstant: 0)
			])
		}
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: titleLabel.text == nil ? 0 : Const.Sizes.verticalCellIndent),
			titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Const.Sizes.horizontalIndent),
			titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Const.Sizes.horizontalIndent),

			textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Const.Sizes.smallVerticalIndent),
			textField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
			textField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
			textField.heightAnchor.constraint(equalToConstant: Const.Sizes.textFieldHeight),

			underlineView.topAnchor.constraint(equalTo: textField.bottomAnchor),
			underlineView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
			underlineView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
			underlineView.heightAnchor.constraint(equalToConstant: 2),
			underlineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Const.Sizes.verticalCellIndent),
		])
	}

	private func setupUI() {
		backgroundColor = .clear
		textField.backgroundColor = .clear
		textField.font = Design.Fonts.normal
		textField.attributedPlaceholder =
			NSAttributedString(string: placeHolderText,
							   attributes: [NSAttributedString.Key.foregroundColor: Design.Colors.dsBorder0,
											NSAttributedString.Key.font: Design.Fonts.small])
		textField.tintColor = Design.Colors.dsTextHighlighted
		textField.textColor = Design.Colors.dsTextHighlighted
		underlineView.backgroundColor = Design.Colors.dsBorder0
	}
}

extension TextFieldCell: UITextFieldDelegate {

	func textFieldDidChangeSelection(_ textField: UITextField) {
		output?.textChangedTo(newValue: textField.text, forTag: editionAimTag)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		endEditing(true)
		return false
	}
}
