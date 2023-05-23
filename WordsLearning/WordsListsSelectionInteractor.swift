//
//  WordsSelectionInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол сервиса хранения данных для списка изучения слов
protocol WordsListStorageServiceProtocol {

	/// Загрузить слова
	/// - Parameter complition: замыкание, возвращающее загруженный список слов
	func loadWords(complition: @escaping ([Word]) -> ())

	/// Создать список слов
	/// - Parameter newWordsList: новый список слов
	func create(_ newWordsList: WordsList)

	/// Загрузить списки слов
	func loadWordsLists() -> [WordsList]

	/// Обновидть данные списка слов
	/// - Parameters:
	///   - origWordsList: список
	///   - newName: новое название
	///   - newComment: новый коментарий
	///   - newWords: новый массив слов
	func update(origWordsList: WordsList, newName: String, newComment: String?, newWords: [Word])

	/// Удалить список слов
	/// - Parameter name: название списка слов
	func deleteWordsList(name: String)
}

/// Протокол интерактора сцены выбора слов для изучения
protocol WordsListsSelectionInteractorProtocol {
	
	/// Обновление данных
	func viewDidLoad()

	/// Нажата кнопка создания списка
	func createButtonTapped()

	/// Нажата кнопка отмены
	func cancelButtonTapped()

	/// Нажата кнопка очищения выбора списа
	func clearButtonTapped()
}

/// Интерактор сцены выбора слов для изучения
final class WordsListsSelectionInteractor: WordsListsSelectionInteractorProtocol,
										   SelectWordsListsTableCellOutput {

	/// Презентер сцены
	var presenter: WordsListsSelectionPresenterProtocol?

	private let router: MainRouterProtocol
	private let storageService: WordsListStorageServiceProtocol

	private var wordsLists: [WordsList] = []
	private var selectedList: WordsList?
	private let actionOnClose: (WordsList?) -> Void

	/// Инициализатор
	/// - Parameters:
	///   - router: роутер
	///   - storageService: сервис хранения данных
	///   - currentWordsList: текущий список
	///   - actionOnClose: замыкание, которое будет выполненно при закрытии экрана
	init(router: MainRouterProtocol,
		 storageService: WordsListStorageServiceProtocol,
		 currentWordsList: WordsList?,
		 actionOnClose: @escaping (WordsList?) -> Void) {
		self.storageService = storageService
		self.actionOnClose = actionOnClose
		self.selectedList = currentWordsList
		self.router = router
	}

	func viewDidLoad() {
		fillUIWithDataFromStorage()
	}

	func createButtonTapped() {
		let actionOnClose: (Bool) -> Void = { [weak self] isChanged in
			guard isChanged else { return }
			self?.fillUIWithDataFromStorage()
		}

		let wordsSelection = WordsSelectionAssembler().create(storageService: storageService,
															  editingList: nil,
															  actionOnClose: actionOnClose)
		router.routeModallyTo(wordsSelection)
	}

	func clearButtonTapped() {
		selectedList = nil
		actionOnClose(nil)
		presenter?.closeScene()
	}

	func cancelButtonTapped() {
		presenter?.closeScene()
	}

	// MARK: - SelectWordsListsTableCellOutput

	func cellTappedWith(listName: String) {
		selectedList = wordsLists.first() { $0.name == listName}
		closeSceneReturningSelectedList()
	}

	func cellSelectedToBeRemoved(withWordsListName name: String, completion: @escaping (Bool) -> Void) {
		presenter?.presentListDeletionConfirmation(withName: name) { [weak self] isConfirmed in
			self?.deleteWordsList(name: name)
			completion(isConfirmed)
		}
	}

	func cellSelectedToBeEdited(withWordsListName name: String) {
		let actionOnClose: (Bool) -> Void = { [weak self] isChanged in
			guard isChanged else { return }
			self?.fillUIWithDataFromStorage()
		}

		let listForEdition = storageService.loadWordsLists().first() { $0.name == name }
		let wordsSelection = WordsSelectionAssembler().create(storageService: storageService,
															  editingList: listForEdition,
															  actionOnClose: actionOnClose)
		router.routeModallyTo(wordsSelection)
	}

	// MARK: - Private

	private func fillUIWithDataFromStorage() {
		wordsLists = storageService.loadWordsLists()
		updateUI(with: wordsLists)
	}

	private func closeSceneReturningSelectedList() {
		actionOnClose(selectedList)
		presenter?.closeScene()
	}

	private func deleteWordsList(name: String) {
		storageService.deleteWordsList(name: name)
		wordsLists.removeAll() { $0.name == name }
		presenter?.updateTitleText(to: wordsLists.isEmpty ? "Еще нет ни одного списка 🙃" : "Выбери понравившийся список 😃")
	}

	private func updateUI(with lists: [WordsList]) {
		var items: [DRTableViewCellProtocol] = []
		let listsForUI = lists.sorted { $0.name < $1.name }
		listsForUI.forEach {
			items.append(SelectWordsListsTableCell(name: $0.name,
												   comment: $0.commentString,
												   wordsCount: $0.words.count,
												   isSelected: $0.name == selectedList?.name,
												   output: self))
		}
		let title = listsForUI.isEmpty ? "Пока нет ни одного списка 🙃" :
										 "Выбери понравившийся список 😃"
		presenter?.present(items, title: title)
	}
}
