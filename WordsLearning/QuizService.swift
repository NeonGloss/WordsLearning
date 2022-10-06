//
//  QuizService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 11.08.2022.
//

import UIKit

protocol QuizServiceProtocol: AnyObject {

	var words: [Word] { get }

	func setWords(_ words: [Word])

	/// Выдать слово из набора по рейтингу. Чем выше рейтинг слова, тем выше шанс его выпадения.
	func getNextWord(for direction: TranslationDirection) -> Word?

	/// Обработать изменение слова
	func currentWordWasEdited(parts: EditedWordParts)

	func assertAnswer(_ answer: String, direction: TranslationDirection, putInStatistics: Bool) -> Bool
}

/// Сервис ведения изучения слов
final class QuizService: QuizServiceProtocol {

	private(set) var words: [Word] = []
	private var unstudiedWords: [Word] = []

	private var currentQuestionWord: Word?

	func setWords(_ words: [Word]) {
		self.words = words
	}

	func getNextWord(for direction: TranslationDirection) -> Word? {
		currentQuestionWord = getWordFrom(words, direction: direction)
		return currentQuestionWord
	}

	func currentWordWasEdited(parts: EditedWordParts) {
		currentQuestionWord?.change(with: parts)
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

	// MARK: Private

	private func getWordFrom(_ words: [Word], direction: TranslationDirection) -> Word? {
		guard words.count > 0 else { return nil }
		let raitingSortedWords = words.sorted {
			$0.raiting(direction: direction) > $1.raiting(direction: direction)
		}
		let wordIndex = getRandomIndexUpTo(min(words.count - 1, 10))

		// Логируем текущее состояние массива слов
		print("Word list: word -> perceentFtoN -> perceentNtoF -> raiting\n")
		print("-------------------------- Total: \(raitingSortedWords.count)")
		let wordsForLog = raitingSortedWords.map { ($0.foreign,
													$0.foreingToNativeStatistic.studyPercent,
													$0.nativeToForeignStatistic.studyPercent,
													$0.raiting(direction: direction)) }
		wordsForLog.enumerated().forEach {
			let string = "Word: \($0.1.0)\tFtoN: \($0.1.1)\tNtoF: \($0.1.2)\traiting: \($0.1.3)"
			$0.0 == wordIndex ? print(string + " <<") : print(string)
		}
		// Логируем текущее состояние массива слов

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
}
