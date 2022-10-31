//
//  StatisticsInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 07.10.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол интерактора сцены
protocol StatisticsInteractorProtocol {
	
	/// Обновление данных
	func viewDidLoad()

	func translationSwitcherChanged(to newValue: Bool)
}

/// Интерактор сцены
final class StatisticsInteractor: StatisticsInteractorProtocol {

	/// Презентер сцены
	var presenter: StatisticsPresenterProtocol?
	private var storageService: StorageServiceProtocol

	private var words: [Word] = []

	/// Инициализатор
	/// - Parameters:
	///   - service: сервис
	///   - analyticsService: сервис отправки аналитики
	init(storageService: StorageServiceProtocol) {
		self.storageService = storageService
		storageService.readWords(complition: { [weak self] words in
			self?.wordsWasLoaded(words)
			// TODO: убрать лоадер и разметсить слова если viewDidLoad уже произошло
			self?.updateUI(for: .foreignToNative)
		})
	}

	func viewDidLoad() {
		// TODO: проверить что слова загружены, убрать лоадер и отобразить слова
		updateUI(for: .foreignToNative)
	}

	func translationSwitcherChanged(to newValue: Bool) {
		let translationDirection = newValue == true ? TranslationDirection.nativeToForeign :
																		  .foreignToNative
		updateUI(for: translationDirection)
	}

	private func updateUI(for direction: TranslationDirection) {
		var items: [DRTableViewCellProtocol] = []
		let wordsForUI = makeWordsForUI(from: words, forDirection: direction)
		wordsForUI.forEach { word, remark, studyPercent, raitingForDirection in
			items.append(StatisticsCell(word: word, remark: remark, studyPercent: studyPercent, raiting: raitingForDirection))
		}
		presenter?.presentItems(items)
	}

	// MARK: Privatea

	private func wordsWasLoaded(_ words: [Word]) {
		self.words = words
	}

	func makeWordsForUI(from words: [Word],
						forDirection direction: TranslationDirection) -> [(String, String?, Double, Double)] {
		let raitingSortedWords = words.sorted {
			$0.raiting(direction: direction) > $1.raiting(direction: direction)
		}
		let wordsForStatisticsOutput = raitingSortedWords.map {
			(direction == .foreignToNative ? $0.foreign : $0.native.first ?? "",
			 direction == .foreignToNative ? $0.fToNRemark : $0.nToFRemark ?? nil,
			 direction == .foreignToNative ? $0.foreingToNativeStatistic.studyPercent :
											 $0.nativeToForeignStatistic.studyPercent,
			 $0.raiting(direction: direction))
		}
		return wordsForStatisticsOutput
	}
}
