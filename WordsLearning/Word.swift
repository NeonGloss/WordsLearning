//
//  Word.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 04.08.2022.
//

import Foundation
import CryptoKit

enum PartOfSpeech: Codable {

	/// вопросительное слово
	case questionWord

	/// прилогательное
	case adjective

	/// союз
	case pretext

	/// другое
	case other

	/// глагол
	case verb

	/// существительное
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
	
	var shaHash: String {
		let inputString = foreign + native.joined()
		let inputData = Data(inputString.utf8)
		let hashDigest = SHA256.hash(data: inputData)
		return hashDigest.compactMap { String(format: "%02x", $0) }.joined()
	}

	/// Инициализатор, если не указывается часть речи, то по умолчанию - существительное
	/// - Parameters:
	///   - foreign: слово на иностранном языке
	///   - native: слово на родном языке
	///   - transcription: транскрипция
	///   - partOfSpeech: часть речи
	init(foreign: String,
		 native: [String],
		 transcription: String,
		 partOfSpeech: PartOfSpeech = .noun,
		 fToNRemark: String? = nil,
		 nToFRemark: String? = nil) {
		self.transcription = transcription
		self.partOfSpeech = partOfSpeech
		self.fToNRemark = fToNRemark
		self.nToFRemark = nToFRemark
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

		// рейтинг от 1 до 101
		var rating: Double = 101 - statistic.studyPercent

		// чем больше процент не правильных ответов, тем выше рейтинг
		let wrongAnswersMultiplier = (1.01 - min(max(statistic.successPercent / 100, 0), 1))

		// чем чаще слово повторяли, тем меньше рейтинг
		let repetitionRateMultiplier = exp(-Double(statistic.totalAnswers) * 0.07)

		// если последний ответ был неправильным увеличиваем рейтинг
		let lastAnswerCorrectMultiplier = statistic.isLastAnswerWasCorrcet ? 1 : 1.5

		// чем дольше слово не повторяли, тем выше рейтинг
		let daysFromLastQuestion = NSCalendar.current.numberOfDaysBetween(statistic.lastQuestionDate, and: Date())
		let timeMultiplier = log10(Double(daysFromLastQuestion + 5)) + 1

		rating = rating *
				 wrongAnswersMultiplier *
				 repetitionRateMultiplier *
				 lastAnswerCorrectMultiplier *
				 timeMultiplier
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

	/// Устанавливает слово как изученное добавляя необходимое количество правильных ответов согласно дельте прибавляемой к проценту изучения за каждый правильный ответ
	/// - Parameters:
	///   - direction: направление перевода
	///   - useingDeltaPercent: процент за правильный ответ
	func markAsStudied(for direction: TranslationDirection, useingDeltaPercent: Int, date: Date) {
		let statistics = direction == .foreignToNative ? foreingToNativeStatistic : nativeToForeignStatistic
		var numberOfAnswersToBeStudied: Int = Int((100 - Int(statistics.studyPercent)) / useingDeltaPercent) + 1
		while numberOfAnswersToBeStudied != 0 {
			updateStatistics(direction: direction,
							 lastAnswerIsCorrect: true,
							 percentDelta: useingDeltaPercent,
							 lastAnswerDate: date)
			numberOfAnswersToBeStudied -= 1
		}

	}

	/// Обновить данные слова
	/// - Parameter parts: части слова
	func update(with parts: EditedWordParts) {
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

/// From the documentation: “Hash values are not guaranteed to be equal across different executions of your program.”
extension Word: Hashable {

	func hash(into hasher: inout Hasher) {
		hasher.combine(foreign)
        hasher.combine(native)
	}
}
