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

	func sortSwitcherChanged(to newValue: Bool)
}

/// Интерактор сцены
final class StatisticsInteractor: StatisticsInteractorProtocol {

	/// Презентер сцены
	var presenter: StatisticsPresenterProtocol?
	var router: StatisticsRouterProtocol?
	private let storageService: StorageServiceProtocol

	private enum SortType {
		case foreignAlfabaticaly
		case fToNStudyPercent
	}

	private var currentSort: SortType
	private var words: [Word] = []

	/// Инициализатор
	/// - Parameters:
	///   - service: сервис
	init(storageService: StorageServiceProtocol) {
		self.storageService = storageService
		currentSort = .fToNStudyPercent
		storageService.readWords(complition: { [weak self] words in
			self?.wordsWasLoaded(words)
			// TODO: убрать лоадер и разметсить слова если viewDidLoad уже произошло
			self?.updateUI()
		})
	}

	func viewDidLoad() {
		// TODO: проверить что слова загружены, убрать лоадер и отобразить слова
		updateUI()
	}

	func sortSwitcherChanged(to newValue: Bool) {
		currentSort = currentSort == .foreignAlfabaticaly ? .fToNStudyPercent : .foreignAlfabaticaly

		updateUI()
	}

	// MARK: - Private

	private func updateUI() {
		var items: [DRTableViewCellProtocol] = []

		var wordsForUI = words.sorted { $0.foreign < $1.foreign }
		if currentSort == .fToNStudyPercent {
			wordsForUI = wordsForUI.sorted { $0.foreingToNativeStatistic.studyPercent < $1.foreingToNativeStatistic.studyPercent }
		}

		wordsForUI.forEach {
			items.append(StatisticsCell(word: $0, output: self))
		}
		presenter?.presentItems(items)
	}


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

extension StatisticsInteractor: StaticsticsCellOutput {

	func cellTappedWithWord(_ word: Word) {
		let actionOnEditionClose: (EditedWordParts?) -> Void = { [weak self] parts in
			guard let parts = parts else { return }
			self?.wordWasUpdated(word, withParts: parts)
		}
		let editionViewController = WordEditionAssembler().create(for: word, actionOnClose: actionOnEditionClose)
		router?.routeModallyTo(editionViewController)
	}

	func cellTappedForDeletionWithWord(_ wordForDeletion: Word, complition: @escaping (Bool) -> ()) {
		words.removeAll { $0.foreign == wordForDeletion.foreign }
		storageService.saveWords(words) { result in
			complition(result)
		}
	}

	// MARK: Private

	private func wordWasUpdated(_ word: Word, withParts parts: EditedWordParts) {
		word.update(with: parts)
		updateUI()
	}
}
