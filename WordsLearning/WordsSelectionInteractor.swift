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

	/// Нажата кнопка "сохранить"
	func saveButtonTapped()

	/// Изменилось название списка
	/// - Parameter newName: новое название
	func listNameChanged(to newName: String)

	/// Нажата кнопка закрытия без сохранения
	func dismissButtonTapped()
}

/// Интерактор сцены выбора слов для изучения
final class WordsSelectionInteractor: WordsSelectionInteractorProtocol {

	/// Презентер сцены
	var presenter: WordsSelectionPresenterProtocol?

	private var storageService: WordsListStorageServiceProtocol

	private enum SortType {
		case foreignAlfabaticaly
		case fToNStudyPercent
	}

	private let editingList: WordsList?
	private var currentSort: SortType
	private var allWords: [Word] = []
	private var listName: String?
	private var selectedWords: [Word] = []
	private let actionOnClose: (Bool) -> Void

	/// Инициализатор
	/// - Parameters:
	///   - storageService: сервис хранения данных
	///   - editingList: список для изменения
	///   - actionOnClose: замыкание, которое будет выполненно при закрытии экрана
	init(storageService: WordsListStorageServiceProtocol,
		 editingList: WordsList?,
		 actionOnClose: @escaping (Bool) -> Void) {
		self.storageService = storageService
		self.actionOnClose = actionOnClose
		currentSort = .fToNStudyPercent
		self.editingList = editingList

		selectedWords = editingList?.words ?? []
		listName = editingList?.name
		storageService.loadWords { [weak self] words in
			self?.allWords = words
		}
	}

	func viewDidLoad() {
		updateUI()
	}

	func sortSwitcherChanged(to newValue: Bool) {
		currentSort = currentSort == .foreignAlfabaticaly ? .fToNStudyPercent : .foreignAlfabaticaly
		updateUI()
	}

	func cleanSelectionButtonTapped() {
		selectedWords = []
		presenter?.clearSelection()
	}

	func saveButtonTapped() {
		guard let newListName = listName,
			  // TODO: add warning
			  !newListName.isEmpty,
			  !selectedWords.isEmpty else { return }
		if let editingList = editingList {
			storageService.update(origWordsList: editingList, newName: newListName, newComment: nil, newWords: selectedWords)
		} else {
			let newList = WordsList(name: newListName, commentString: nil, words: selectedWords)
			storageService.create(newList)
		}

		actionOnClose(true)
		presenter?.closeScene()
	}

	func viewWillDisappear() {
		presenter?.closeScene()
	}

	func dismissButtonTapped() {
		presenter?.closeScene()
	}

	func listNameChanged(to newName: String) {
		listName = newName
	}

	// MARK: - Private

	private func checkIfNameEntered() -> Bool {
		guard let listName = listName else { return false}
		return !listName.isEmpty
	}

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
		presenter?.present(listName: listName, items: items, selectedWordsCount: selectedWords.count)
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
		presenter?.setSelectedWordCountTo(selectedWords.count)
	}

	func cellTappedForDeletionWithWord(_ wordForDeletion: Word, complition: @escaping (Bool) -> ()) {}
}
