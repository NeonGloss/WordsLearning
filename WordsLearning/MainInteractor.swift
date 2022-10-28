//
//  MainInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 14.07.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import Foundation

enum TranslationDirection {

	case foreignToNative
	case nativeToForeign
}

/// Протокол интерактора сцены
protocol MainInteractorProtocol {
	
	/// Обновление данных
	func viewDidLoad()

	/// Получен ответ от пользователя
	/// - Parameter answer: ответ
	func answerReceived(_ answer: String)

	func contrverseTranslationSwitcherChanged(to newValue: Bool)

	func editWordTapped()

	func menuButtonTapped()

	func markStudiedTapped()
}

/// Интерактор сцены
final class MainInteractor: MainInteractorProtocol {

	/// Презентер сцены
	var presenter: MainPresenterProtocol?

	private let router: MainRouterProtocol
	private var currentQuestionWord: Word?
	private let quizService: QuizServiceProtocol
	private let storageService: StorageServiceProtocol
	private var translationDirection: TranslationDirection = .foreignToNative
	private var isFirstAnswerReceived: Bool = false

	/// Инициализатор
	/// - Parameters:
	///   - router: роутер
	///   - quizService: сервис теста
	///   - storageService: сервис хранения данных
	init(router: MainRouterProtocol,
		 quizService: QuizServiceProtocol,
		 storageService: StorageServiceProtocol) {
		self.router = router
		self.quizService = quizService
		self.storageService = storageService
		storageService.readWords(complition: { [weak self] words in
			self?.wordsWasLoaded(words)
			// TODO: dismissLoader
			self?.askQuestion()
		})
	}

	func viewDidLoad() {
		askQuestion()
	}

	func answerReceived(_ answer: String) {
		guard let currentQuestionWord = currentQuestionWord else { return }

		if quizService.assertAnswer(answer, direction: translationDirection, putInStatistics: !isFirstAnswerReceived) {
			presenter?.showSuccess(for: currentQuestionWord) { [weak self] in
				self?.askQuestion()
			}
		} else {
			presenter?.showThatMistakeMade(word: currentQuestionWord, enteredAnswer: answer) { [weak self] in
				self?.presenter?.cleanAnswerField()
			}
		}
		// TODO: сохранение нужно перенести в место, где это будет происходить реже
		if !isFirstAnswerReceived {
			storageService.saveWords(quizService.words) { _ in }
		}
		isFirstAnswerReceived = true
	}

	func contrverseTranslationSwitcherChanged(to newValue: Bool) {
		translationDirection = newValue == true ? .nativeToForeign : .foreignToNative
		askQuestion()
	}

	func editWordTapped() {
		guard let currentWord = currentQuestionWord else { return }
		let actionOnEditionClose: (EditedWordParts?) -> Void = { [weak self] parts in
			guard let parts = parts else { return }
			self?.currentWordWasEdited(parts: parts)
		}
		let editionViewController = WordEditionAssembler().create(for: currentWord, actionOnClose: actionOnEditionClose)
		router.routeModallyTo(editionViewController)
	}

	func menuButtonTapped() {
		let menuViewController = SettingsAssembler().create()
		router.routeTo(menuViewController)
	}

	func markStudiedTapped() {
		quizService.markCurrentWordAsStudied(forDirection: translationDirection)
		askQuestion()
	}

	// MARK: Private

	private func wordsWasLoaded(_ words: [Word]) {
		quizService.setWords(words)
		askQuestion()
	}

	private func askQuestion() {
		guard let word = quizService.getNextWord(for: translationDirection) else { return }
		currentQuestionWord = word
		isFirstAnswerReceived = false
		fillUIWith(word)
	}

	private func getRandomIndexUpTo(_ upperBound: Int) -> Int {
		Int.random(in: 0...upperBound)
	}

	private func currentWordWasEdited(parts: EditedWordParts) {
		currentQuestionWord?.change(with: parts)
		guard let word = currentQuestionWord else { return }
		quizService.currentWordWasEdited(parts: parts)
		fillUIWith(word)
	}

	private func fillUIWith(_ word: Word) {
		presenter?.cleanAnswerField()
		let secondLanugageIndex = getRandomIndexUpTo(word.native.count - 1)
		let questionString = translationDirection == .foreignToNative ?
			word.foreign : word.native[secondLanugageIndex]
		let studyPercent = translationDirection == .foreignToNative ? word.foreingToNativeStatistic.studyPercent : word.nativeToForeignStatistic.studyPercent
		presenter?.askWord(wordString: questionString, studyPercent: String(studyPercent))
	}
}
