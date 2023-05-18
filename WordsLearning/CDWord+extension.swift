//
//  CDWord+extension.swift
//  WordsLearning
//
//  Created by Roman on 16/05/2023.
//

import UIKit

extension CDWord {

	/// Возвращает объект типа Word
	var word: Word? {
		guard let native = native,
			  let foreign = foreign,
			  let transcription = transcription,
			  let partOfSpeechString = partOfSpeech else { return nil }

		let foreignFormStudyStatistics = WordStatistic(isLastAnswerWasCorrcet: self.isLastAnswerForForeignWasCorrect,
													   lastQuestionDate: self.foreignLastQuestionDate ?? Date(),
													   successAnswersCount: Int(self.correctAnswersCountForForeignQuestion),
													   errorAnswersCount: Int(self.wrongAnswersCountForForeignQuestion),
													   studyPercent: self.foreignStudyPercent)

		let nativeFormStudyStatistics = WordStatistic(isLastAnswerWasCorrcet: self.isLastAnswerForNativeWasCorrect,
													  lastQuestionDate: nativeLastQuestionDate ?? Date(),
													  successAnswersCount: Int(self.correctAnswersCountForNativeQuestion),
													  errorAnswersCount: Int(self.wrongAnswersCountForNativeQuestion),
													  studyPercent: self.nativeStudyPercent)

		return Word(foreign: foreign,
					native: native.components(separatedBy: ","),
					transcription: transcription,
					partOfSpeech: PartOfSpeech(rawValue: partOfSpeechString) ?? .noun,
					fToNRemark: self.foreignComment,
					nToFRemark: self.nativeComment,
					foreingToNativeStatistic: foreignFormStudyStatistics,
					nativeToForeignStatistic: nativeFormStudyStatistics)
		
	}

	/// Обновить свойства объекта в соответствии с переданными данными слова. Сохраняет изменения в контексте CoreData.
	/// - Parameter word: слово
	func update(with word: Word) {
		foreign = word.foreign
		nativeComment = word.nToFRemark
		foreignComment = word.fToNRemark
		transcription = word.transcription
		partOfSpeech = word.partOfSpeech.rawValue
		native = word.native.joined(separator: ",")
		nativeStudyPercent = word.nativeToForeignStatistic.studyPercent
		foreignStudyPercent = word.foreingToNativeStatistic.studyPercent
		nativeLastQuestionDate = word.nativeToForeignStatistic.lastQuestionDate
		foreignLastQuestionDate = word.foreingToNativeStatistic.lastQuestionDate
		isLastAnswerForNativeWasCorrect = word.nativeToForeignStatistic.isLastAnswerWasCorrcet
		isLastAnswerForForeignWasCorrect = word.foreingToNativeStatistic.isLastAnswerWasCorrcet
		wrongAnswersCountForNativeQuestion = Int64(word.nativeToForeignStatistic.errorAnswersCount)
		wrongAnswersCountForForeignQuestion = Int64(word.foreingToNativeStatistic.errorAnswersCount)
		correctAnswersCountForNativeQuestion = Int64(word.nativeToForeignStatistic.successAnswersCount)
		correctAnswersCountForForeignQuestion = Int64(word.foreingToNativeStatistic.successAnswersCount)

		managedObjectContext?.save(errorMSG: "📀💿❌ не удалось сохранить изменение слова в CoreData")
	}
}
