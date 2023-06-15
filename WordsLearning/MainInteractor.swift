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
protocol MainInteractorProtocol: ExtraCapabilitiesViewOutput {
	
	/// Обновление данных
	func viewDidLoad()

	/// Получен ответ от пользователя
	/// - Parameter answer: ответ
	func answerReceived(_ answer: String)

	func editWordTapped()

	func menuButtonTapped()

	func markStudiedTapped()

	func repeatButtonTapped()

	func shuffleButtonTapped()

	/// Нажата кнопка меню дополнительных функций
	func extraCapabilitiesButtonTapped()
}

/// Интерактор сцены
final class MainInteractor: MainInteractorProtocol,
							ExtraCapabilitiesViewOutput {

	/// Презентер сцены
	var presenter: MainPresenterProtocol?

	private let notificationService: NotificationServiceProtocol
	private let storageService: StorageServiceProtocol
	private let quizService: QuizServiceProtocol
	private let router: MainRouterProtocol

	private var translationDirection: TranslationDirection = .foreignToNative
    private var isFirstAnswerReceived: Bool = false
    private var isShuffleTurnedOn: Bool = false
    private var isRepeatTurnedOn: Bool = false
	private var currentWordsList: WordsList?
	private var currentQuestionWord: Word?
	private var allWords: [Word] = []

	/// Инициализатор
	/// - Parameters:
	///   - router: роутер
	///   - quizService: сервис теста
	///   - storageService: сервис хранения данных
	init(router: MainRouterProtocol,
		 quizService: QuizServiceProtocol,
		 storageService: StorageServiceProtocol,
         notificationService: NotificationServiceProtocol) {
		self.router = router
		self.quizService = quizService
		self.storageService = storageService
        self.notificationService = notificationService
        
        startRepeadedLearningSuggestionNotification()
        readWordsFromStorage() { [weak self] in self?.wordsWasLoaded($0) }
	}

	func viewDidLoad() {
		askQuestion()
	}

	func answerReceived(_ answer: String) {
		guard let currentQuestionWord = currentQuestionWord else { return }

		if isRepeatTurnedOn {
			assertAndRepeatWord(currentAnswer: answer)
		} else if quizService.assertAnswer(answer, direction: translationDirection, putInStatistics: !isFirstAnswerReceived) {
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

	func contrverseTranslationSwitcherChanged() {
		presenter?.showOrHideCapabilitiesMenu()
		translationDirection = translationDirection == .nativeToForeign ? .foreignToNative : .nativeToForeign
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

	func repeatButtonTapped() {
		isRepeatTurnedOn = !isRepeatTurnedOn
	}

	func shuffleButtonTapped() {
		isShuffleTurnedOn = !isShuffleTurnedOn
	}

	func showAllWordsButtonTapped() {
		presenter?.showOrHideCapabilitiesMenu()
		let statisticsVC = StatisticsAssembler().create()
		router.routeTo(statisticsVC)
	}
    
    func selectWordsButtonTapped() {
		presenter?.showOrHideCapabilitiesMenu()
		let actionOnClose: (WordsList?) -> Void = { [weak self] wordsList in
			self?.wordsListWasSelectedForStudy(wordsList)
		}
		let wordsSelection = WordsListsSelectionAssembler().create(currentWordsList: currentWordsList,
																   actionOnClose: actionOnClose)
		router.routeModallyTo(wordsSelection)
    }

	func extraCapabilitiesButtonTapped() {
		presenter?.showOrHideCapabilitiesMenu()
	}

	// MARK: Private
    
    private func readWordsFromStorage(completion: @escaping ([Word]) -> Void) {
        storageService.readWords() { completion($0) }
    }
    
    private func startRepeadedLearningSuggestionNotification() {
        notificationService.requestRights { [weak self] isGranted in
            guard isGranted else { return }
            let title = "Пора поучить слова"
            let bodyText = "Если учить по 10 слов в день, то через 10 дней ты будешь знать 100 новых слов!!"
            self?.notificationService.sendNotificationWith(title: title, body: bodyText, secondsInterval: 3600)
        }
    }

	private func wordsWasLoaded(_ words: [Word]) {
        quizService.setWords(words)
        allWords = words
		askQuestion()
	}

	private func askQuestion() {
		let nextWord = isShuffleTurnedOn ? quizService.getNextWordByShuffle(for: translationDirection) :
										   quizService.getNextWordByRaiting(for: translationDirection)
		guard let nextWord = nextWord else { return }
		currentQuestionWord = nextWord
		isFirstAnswerReceived = false
		fillUIWith(nextWord)
	}

	private func getRandomIndexUpTo(_ upperBound: Int) -> Int {
		Int.random(in: 0...upperBound)
	}

	private func currentWordWasEdited(parts: EditedWordParts) {
		currentQuestionWord?.update(with: parts)
		guard let word = currentQuestionWord else { return }
		quizService.currentWordWasEdited(parts: parts)
		fillUIWith(word)
	}
    
	private func wordsListWasSelectedForStudy(_ wordsList: WordsList?) {
		currentWordsList = wordsList
		presenter?.presentListName(wordsList?.name)

		var resultedWordsForStudy: [Word] = []
		if let wordsList = wordsList,
		   !wordsList.words.isEmpty {
			resultedWordsForStudy = wordsList.words
		} else {
			resultedWordsForStudy = allWords
		}

		quizService.setWords(resultedWordsForStudy)
		askQuestion()
    }

	private func fillUIWith(_ word: Word) {
		presenter?.cleanAnswerField()
		let secondLanugageIndex = getRandomIndexUpTo(word.native.count - 1)
		let questionString = translationDirection == .foreignToNative ?
			word.foreign : word.native[secondLanugageIndex]
		let studyPercent = translationDirection == .foreignToNative ? word.foreingToNativeStatistic.studyPercent : word.nativeToForeignStatistic.studyPercent
		let remark = translationDirection == .foreignToNative ? word.fToNRemark : word.nToFRemark
		presenter?.askWord(wordString: questionString,
						   remark: remark,
						   studyPercent: String(format: "%.0f", studyPercent) + "%")
	}

	private func assertAndRepeatWord(currentAnswer answer: String) {
		guard let currentQuestionWord = currentQuestionWord else { return }
		if quizService.assertAnswer(answer, direction: translationDirection, putInStatistics: false) {
			presenter?.showSuccess(for: currentQuestionWord) { [weak self] in
				self?.presenter?.cleanAnswerField()
			}
		} else {
			presenter?.showThatMistakeMade(word: currentQuestionWord, enteredAnswer: answer) { [weak self] in
				self?.presenter?.cleanAnswerField()
			}
		}
	}
}
