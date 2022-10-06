//
//  MainPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол презентера сцены
protocol MainPresenterProtocol {

	func askWord(wordString: String)

	func showThatMistakeMade(word: Word, enteredAnswer: String, completion: @escaping () -> Void)

	func cleanAnswerField()

	func showSuccess(for: Word, completion: @escaping () -> Void)
}

/// Презентер сцены
final class MainPresenter: MainPresenterProtocol {

	private weak var viewController: MainViewControllerProtocol?
	private let alertService: AlertServiceProtocol

	/// Инициализатор
	/// - Parameter viewController: вью-контроллер сцены
	init(viewController: MainViewControllerProtocol, alertService: AlertServiceProtocol) {
		self.viewController = viewController
		self.alertService = alertService
	}

	func askWord(wordString: String) {
		viewController?.displayWordQuestion(question: wordString)
	}

	func cleanAnswerField() {
		viewController?.cleanAnswerField()
	}

	func showThatMistakeMade(word: Word, enteredAnswer: String, completion: @escaping () -> Void) {
		guard let viewController = viewController else {
			return
		}
		let buttonSettings = ButtonSettins(title: "ОК", actionOnTap: completion)
		let alertMessage = composeMistakeAlertMessage(word: word, enteredAnswer: enteredAnswer)
		alertService.showRichAlert(over: viewController,
								   image: SemanticImages.wrongCircle,
								   title: word.foreign,
								   subtitle: alertMessage,
								   buttonsSettings: [buttonSettings])
	}

	func showSuccess(for word: Word, completion: @escaping () -> Void) {
		guard let viewController = viewController else { return }
		let buttonSettings = ButtonSettins(title: "ОК", actionOnTap: completion)
		let alertMessage = composeSuccessAlertMessage(for: word)
		alertService.showRichAlert(over: viewController,
								   image: SemanticImages.checkmarkCircle,
								   title: word.foreign,
								   subtitle: alertMessage,
								   buttonsSettings: [buttonSettings])
	}

	// MARK: Private

	private func composeMistakeAlertMessage(word: Word, enteredAnswer: String) -> String {
		let answerText = enteredAnswer.isEmpty ? "-" : enteredAnswer
		var text = "[\(word.transcription)]\nВарианты верного ответа: \n\""
		text.append(contentsOf: word.nativeWordsDescription)
		text.append(contentsOf: "\nВаш ответ:\n\(answerText)")
		return text
	}

	private func composeSuccessAlertMessage(for word: Word) -> String {
		var text = "[\(word.transcription)]\n"
		text.append(contentsOf: "\"")
		text.append(contentsOf: word.nativeWordsDescription)
		return text
	}
}
