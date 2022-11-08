//
//  QuizService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 11.08.2022.
//

import UIKit

protocol QuizServiceProtocol: AnyObject {

	/// Слова в изучении
	var words: [Word] { get }

	/// задать список слов для изучения
	/// - Parameter words: массив слов
	func setWords(_ words: [Word])

	/// Выдать слово из набора по рейтингу. Чем выше рейтинг слова, тем выше шанс его выпадения.
	/// - Parameter direction: направление перевода
	func getNextWordByRaiting(for direction: TranslationDirection) -> Word?

	/// Выдать слово из набора в рандомном порядке.
	/// - Parameter direction: направление перевода
	func getNextWordByShuffle(for direction: TranslationDirection) -> Word?

	/// Обработать изменение слова
	func currentWordWasEdited(parts: EditedWordParts)

	/// Проверить ответ
	/// - Parameters:
	///   - answer: указанный ответ
	///   - direction: направление перевода
	///   - putInStatistics: учитывать ли этот ответ в статистике
	func assertAnswer(_ answer: String, direction: TranslationDirection, putInStatistics: Bool) -> Bool

	/// Пометить слово как изученное
	/// - Parameter direction: направление перевода
	func markCurrentWordAsStudied(forDirection direction: TranslationDirection)
}

/// Сервис ведения изучения слов
final class QuizService: QuizServiceProtocol {

	private(set) var words: [Word] = []
	private var unstudiedWords: [Word] = []
	private var currentQuestionWord: Word?

	func setWords(_ words: [Word]) {
		self.words = words
	}

	func getNextWordByRaiting(for direction: TranslationDirection) -> Word? {
		currentQuestionWord = getWordByRaitingFrom(words, direction: direction)
		return currentQuestionWord
	}

	func getNextWordByShuffle(for direction: TranslationDirection) -> Word? {
		let wordIndex = getRandomIndexUpTo(words.count - 1)
		currentQuestionWord = words[wordIndex]
		return currentQuestionWord
	}

	func currentWordWasEdited(parts: EditedWordParts) {
		currentQuestionWord?.update(with: parts)
	}

	func assertAnswer(_ answer: String, direction: TranslationDirection, putInStatistics: Bool) -> Bool {
		guard let currentQuestionWord = currentQuestionWord else { return false }
		let pureNativeAnswers = currentQuestionWord.pureNativeWords
		let pureForeingAnswers = [currentQuestionWord.foreign]
		let pureAnswers = direction == .nativeToForeign ? pureForeingAnswers : pureNativeAnswers
		let isSuccess = pureAnswers.contains(answer)

		if putInStatistics {
			updateWordStatistic(lastAnswerIsCorrect: isSuccess, direction: direction)
		}

		return isSuccess
	}

	func markCurrentWordAsStudied(forDirection direction: TranslationDirection) {
		currentQuestionWord?.markAsStudied(for: direction,
										   useingDeltaPercent: QuizSettings.rightAnswerPercentDelta,
										   date: Date())
	}

	// MARK: Private

	private func getWordByRaitingFrom(_ words: [Word], direction: TranslationDirection) -> Word? {
		guard words.count > 0 else { return nil }
		let raitingSortedWords = words.sorted {
			$0.raiting(direction: direction) > $1.raiting(direction: direction)
		}
		let wordIndex = getRandomIndexUpTo(min(words.count - 1, 10))

		logCurrentStateOfWords(raitingSortedWords: raitingSortedWords, direction: direction)

		currentQuestionWord = raitingSortedWords[wordIndex]
		return currentQuestionWord
	}

	private func updateWordStatistic(lastAnswerIsCorrect: Bool, direction: TranslationDirection) {
		let studyPercentageDelta = lastAnswerIsCorrect ? QuizSettings.rightAnswerPercentDelta :
														 -QuizSettings.wrongAnswerPercentDelta
		currentQuestionWord?.updateStatistics(direction: direction,
											 lastAnswerIsCorrect: lastAnswerIsCorrect,
											 percentDelta: studyPercentageDelta,
											 lastAnswerDate: Date())
		
	}

	private func getRandomIndexUpTo(_ upperBound: Int) -> Int {
		Int.random(in: 0...upperBound)
	}
	/// Логируем текущее состояние массива слов
	/// - Parameter raitingSortedWords: список слов отсортированных по рейтингу
	/// - Parameter direction: направление перевода
	private func logCurrentStateOfWords(raitingSortedWords: [Word], direction: TranslationDirection) {
		print("Word list: word -> perceentFtoN -> perceentNtoF -> raiting\n")
		print("-------------------------- Total: \(raitingSortedWords.count)")
		let wordsForLog = raitingSortedWords.map { ($0.foreign,
													$0.foreingToNativeStatistic.studyPercent,
													$0.nativeToForeignStatistic.studyPercent,
													$0.raiting(direction: direction)) }
		wordsForLog.enumerated().forEach {
			let string = "Word: \($0.1.0)\tFtoN: \($0.1.1)\tNtoF: \($0.1.2)\traiting: \($0.1.3)"
			print(string)
		}
	}
}
