//
//  KeyboardRespondableUIButton.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 05.08.2022.
//

import UIKit

/// Кнопка которая может реагировать на нажатия клавиатуры
final class KeyboardRespondableUIButton: UIButton, UIKeyInput {

	/// Действие при нажатии
	var actionOnTap: (() -> Void)?
	
	override var canBecomeFirstResponder: Bool { true }

	// MARK: UIKeyInput

	var hasText: Bool = true

	func insertText(_ text: String) {}

	func deleteBackward() {}
}
