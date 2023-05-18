//
//  WordStatistic.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.08.2022.
//

import UIKit

/// Объект статистики изучения слова
final class WordStatistic: Codable {

	var lastQuestionDate: Date
	var errorAnswersCount: Int
	var successAnswersCount: Int
	var isLastAnswerWasCorrcet: Bool
	private(set) var studyPercent: Double

	var totalAnswers: Int { successAnswersCount + errorAnswersCount }
	var successPercent: Double { totalAnswers > 0 ? Double(successAnswersCount * 100 / totalAnswers) : 0 }

	/// Иницилизатор по умолчанию
	init() {
		isLastAnswerWasCorrcet = true
		lastQuestionDate = Date()
		successAnswersCount = 0
		errorAnswersCount = 0
		studyPercent = 0
	}

	/// Инициализатор
	/// - Parameters:
	///   - isLastAnswerWasCorrcet: был ли последний ответ верным
	///   - lastQuestionDate: дата последнего вопроса
	///   - successAnswersCount: количество успешных ответов
	///   - errorAnswersCount: количество неверных ответов
	///   - studyPercent: процент изучения слова
	init(isLastAnswerWasCorrcet: Bool,
		 lastQuestionDate: Date,
		 successAnswersCount: Int,
		 errorAnswersCount: Int,
		 studyPercent: Double) {
		self.isLastAnswerWasCorrcet = isLastAnswerWasCorrcet
		self.lastQuestionDate = lastQuestionDate
		self.successAnswersCount = successAnswersCount
		self.errorAnswersCount = errorAnswersCount
		self.studyPercent = studyPercent
	}

	func update(lastAnswerIsCorrect: Bool, percentDelta: Int, lastAnswerDate: Date) {
		isLastAnswerWasCorrcet = lastAnswerIsCorrect
		lastQuestionDate = lastAnswerDate
		if (studyPercent + Double(percentDelta)) > 0, (studyPercent + Double(percentDelta)) <= 100
		{
			studyPercent = (studyPercent + Double(percentDelta))
		} else if (studyPercent + Double(percentDelta)) > 100 {
			studyPercent = 100
		} else {
			studyPercent = 0
		}
		if lastAnswerIsCorrect {
			successAnswersCount += 1
		} else {
			errorAnswersCount += 1
		}
	}
}

extension WordStatistic: Equatable {

	static func == (lhs: WordStatistic, rhs: WordStatistic) -> Bool {
		lhs.errorAnswersCount == rhs.errorAnswersCount &&
		lhs.successAnswersCount == rhs.successAnswersCount &&
		lhs.studyPercent == rhs.studyPercent &&
		lhs.lastQuestionDate == rhs.lastQuestionDate
	}
}
