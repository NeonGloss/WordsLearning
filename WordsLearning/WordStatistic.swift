//
//  WordStatistic.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 16.08.2022.
//

import UIKit

final class WordStatistic: Codable {

	var studyPercent: Double
	var lastQuestionDate: Date
	var errorAnswersCount: Int
	var successAnswersCount: Int
	var isLastAnswerWasCorrcet: Bool

	var totalAnswers: Int { successAnswersCount + errorAnswersCount }
	var successPercent: Double { totalAnswers > 0 ? Double(successAnswersCount * 100 / totalAnswers) : 0 }

	init() {
		isLastAnswerWasCorrcet = true
		lastQuestionDate = Date()
		successAnswersCount = 0
		errorAnswersCount = 0
		studyPercent = 0
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
