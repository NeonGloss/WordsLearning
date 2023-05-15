//
//  WordsSelectionInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол интерактора сцены выбора слов для изучения
protocol WordsSelectionInteractorProtocol {
	
	/// Обновление данных
	func viewDidLoad()

	/// Обработка события закрытия сцены
	func viewWillDisappear()

	/// Обработка изменения состояния переключателя сортировки
	/// - Parameter newValue: новое значение
	func sortSwitcherChanged(to newValue: Bool)

	/// Очистить выделение
	func cleanSelectionButtonTapped()

	/// Обработка нажатия кнопки применения выделения
	func applyButtonTapped()
}

/// Интерактор сцены выбора слов для изучения
final class WordsSelectionInteractor: WordsSelectionInteractorProtocol {

	/// Презентер сцены
	var presenter: WordsSelectionPresenterProtocol?

	private enum SortType {
		case foreignAlfabaticaly
		case fToNStudyPercent
	}

	private var currentSort: SortType
	private var allWords: [Word] = []
	private var selectedWords: [Word] = []
	private let actionOnClose: ([Word]) -> Void

	/// Инициализатор
	/// - Parameters:
	///   - words: роутер
	///   - actionOnClose: замыкание, которое будет выполненно при закрытии экрана
	init(words: [Word], alreadySelectedWords: [Word], actionOnClose: @escaping ([Word]) -> Void) {
		selectedWords = alreadySelectedWords
		self.actionOnClose = actionOnClose
		currentSort = .fToNStudyPercent
		allWords = words
	}

	func viewDidLoad() {
		// TODO: проверить что слова загружены, убрать лоадер и отобразить слова
		updateUI()
	}

	func sortSwitcherChanged(to newValue: Bool) {
		currentSort = currentSort == .foreignAlfabaticaly ? .fToNStudyPercent : .foreignAlfabaticaly
		updateUI()
	}

	func cleanSelectionButtonTapped() {
		selectedWords = []
		presenter?.cleanSelection(numberOfAllWords: allWords.count)
	}

	func applyButtonTapped() {
		actionOnClose(selectedWords)
		presenter?.closeScene()
	}

	func viewWillDisappear() {
		actionOnClose(selectedWords)
	}

	// MARK: - Private

	private func updateUI() {
		var items: [DRTableViewCellProtocol] = []
		var wordsForUI = allWords.sorted { $0.foreign < $1.foreign }
		if currentSort == .fToNStudyPercent {
			wordsForUI = wordsForUI.sorted { $0.foreingToNativeStatistic.studyPercent < $1.foreingToNativeStatistic.studyPercent }
		}

		wordsForUI.forEach {
			items.append(SelectWordsTableCell(word: $0,
											  isSelectedForPartialStudy: selectedWords.contains($0),
											  output: self))
		}
		presenter?.presentItems(items)
		presenter?.setSelectedWordCountTo(selectedWords.count != 0 ? selectedWords.count : items.count)
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

extension WordsSelectionInteractor: SelectWordsTableCellOutput {

	func cellTappedWithWord(_ word: Word) {
		if selectedWords.contains(word) {
			selectedWords.removeAll { $0.foreign == word.foreign }
		} else {
			selectedWords.append(word)
		}
		presenter?.setSelectedWordCountTo(selectedWords.count == 0 ? allWords.count : selectedWords.count)
	}

	func cellTappedForDeletionWithWord(_ wordForDeletion: Word, complition: @escaping (Bool) -> ()) {}
}
