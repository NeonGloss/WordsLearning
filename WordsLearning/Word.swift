//
//  Word.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 04.08.2022.
//

import Foundation

enum PartOfSpeech: Codable {

	case questionWord
	case adjective
	case pretext
	case other
	case verb
	case noun
}

final class Word: Codable {

	private(set) var foreign: String
	private(set) var native: [String]
	private(set) var transcription: String
	private(set) var partOfSpeech: PartOfSpeech
	private(set) var fToNRemark: String?
	private(set) var nToFRemark: String?


	private(set) var foreingToNativeStatistic: WordStatistic = WordStatistic()
	private(set) var nativeToForeignStatistic: WordStatistic = WordStatistic()

	/// Инициализатор, если не указывается часть речи, то по умолчанию - глагол
	/// - Parameters:
	///   - foreign: слово на иностранном языке
	///   - native: слово на родном языке
	///   - transcription: транскрипция
	///   - partOfSpeech: часть речи
	init(foreign: String,
		 native: [String],
		 transcription: String,
		 partOfSpeech: PartOfSpeech = .verb,
		 fToNRemark: String? = nil,
		 nToFRemark: String? = nil) {
		self.transcription = transcription
		self.partOfSpeech = partOfSpeech
		self.foreign = foreign
		self.native = native
	}

	var nativeWordsDescription: String {
		var result: String = ""
		self.native.forEach {
			guard let index = self.native.lastIndex(of: $0) else { return }
			let element = $0.lowercased()
			if index == 0 {
				result.append(contentsOf: element)
			} else if index != self.native.count - 1 {
				result.append(contentsOf: ", ")
				result.append(contentsOf: element)
			} else {
				result.append(contentsOf: " или \"\(element)")
			}
			result.append(contentsOf: "\"")
		}
		return result
	}

	var pureNativeWords: [String] {
		let pureNativeWords = self.native.map { element -> String in
			var newValue = element
			if let bracketStringIndex = newValue.firstIndex(of: "(") {
				newValue = String(newValue[..<bracketStringIndex])
			}
			return newValue
		}
		return pureNativeWords
	}

	func raiting(direction: TranslationDirection) -> Double {
		let statistic = direction == .foreignToNative ? foreingToNativeStatistic : nativeToForeignStatistic
		let learningPercent = statistic.successPercent

		// рейтинг от 1 до 101
		var rating: Double = 101 - statistic.studyPercent
		// чем больше процент не правильных ответов, тем выше рейтинг
		rating *= (1.01 - min(max(learningPercent / 100, 0), 1))
		// чем чаще слово повторяли, тем меньше рейтинг
		rating *= exp(-Double(statistic.totalAnswers) * 0.07)
		// если последний ответ был неправильным увеличиваем рейтинг
		if !statistic.isLastAnswerWasCorrcet {
			rating *= 1.5
		}
		// чем дольше слово не повторяли, тем выше рейтинг
		let daysFromLastQuestion = NSCalendar.current.numberOfDaysBetween(statistic.lastQuestionDate, and: Date())
		rating *= log10(Double(daysFromLastQuestion + 1)) + 1

		return max(rating, 0.1)
	}

	func updateStatistics(direction: TranslationDirection,
						  lastAnswerIsCorrect: Bool,
						  percentDelta: Int,
						  lastAnswerDate: Date) {
		let statistics = direction == .foreignToNative ? foreingToNativeStatistic : nativeToForeignStatistic
		statistics.update(lastAnswerIsCorrect: lastAnswerIsCorrect,
						  percentDelta: percentDelta,
						  lastAnswerDate: lastAnswerDate)

	}

	func change(with parts: EditedWordParts) {
		transcription = parts.transcription
		fToNRemark = parts.fToNRemark
		nToFRemark = parts.nToFRemark
		foreign = parts.foreign
		native = parts.native
	}
}

extension Word: Equatable {

	static func == (lhs: Word, rhs: Word) -> Bool {
		lhs.foreign == rhs.foreign
	}
}

extension Word: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(foreign)
	}
}
