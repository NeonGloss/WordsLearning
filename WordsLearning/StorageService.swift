//
//  StorageService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 12.08.2022.
//

import Foundation

/// Протокол сервиса доступа к данным (Data Access Object Protocol)
protocol DAOProtocol {

	/// Сохранить слова
	/// - Parameters:
	///  - words: замыкание с флагом успеха сохранения данных
	///  - completion: замыкание, возвращающее флаг успеха сохранения
	func saveWords(_ words: [Word], completion: ((Bool) -> Void)?)

	/// Загрузить слова
	/// - Parameter complition: замыкание, возвращающее загруженный список слов
	func loadWords(complition: @escaping ([Word]) -> ())

	/// Загрузить списки слов
	func loadWordsLists() -> [WordsList]

	/// Создать список слов
	/// - Parameter newWordsList: новый список слов
	func create(_ newWordsList: WordsList)

	/// Удалить список слов
	/// - Parameter name: название списка слов
	func deleteWordsList(name: String)

	/// Обновидть данные списка слов
	/// - Parameters:
	///   - origWordsList: список
	///   - newName: новое название
	///   - newComment: новый коментарий
	///   - newWords: новый массив слов
	func update(origWordsList: WordsList, newName: String, newComment: String?, newWords: [Word])

	/// Пересохранить слово с изменениями
	/// - Parameters:
	///   - origWord: изначальное слово
	///   - newWordParts: новые свойства слова
	///   - completion: замыкание, возвращает true - если изменения сохранились успешно
	func update(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void)
}

/// Протокол сервиса хранения данных
protocol StorageServiceProtocol {

	/// Сохранить слова
	/// - Parameter list: список приложений партнеров
	func saveWords(_ words: [Word], completion: @escaping (Bool) -> Void)

	/// Прочитать слова
	/// - Parameter complition: блок кода выполняемый после загрузки данных
	func readWords(complition: @escaping ([Word]) -> ())
}

/// Сервис хранения данных
final class StorageService: StorageServiceProtocol,
							WordsListStorageServiceProtocol,
							WordEditionStorageServiceProtocol {

	private let specificStorageService: DAOProtocol

	/// Инициализатор
	/// - Parameter specificStorage: сервис работы с памятью
	init(specificStorage: DAOProtocol) {
		specificStorageService = specificStorage
	}

	// MARK: - StorageServiceProtocol

	func saveWords(_ words: [Word], completion: @escaping (Bool) -> Void) {
		specificStorageService.saveWords(words, completion: completion)
	}

	func readWords(complition: @escaping ([Word]) -> ()) {
		var resultedWords: [Word] = []
		specificStorageService.loadWords { [weak self] loadedWords in
			guard let self = self else { return }
			resultedWords = self.addDefaultWords(to: loadedWords)
			complition(resultedWords)
		}
	}

	// MARK: - WordsListStorageServiceProtocol

	func loadWordsLists() -> [WordsList] {
		specificStorageService.loadWordsLists()
	}

	func loadWords(complition: @escaping ([Word]) -> ()) {
		specificStorageService.loadWords(complition: complition)
	}

	func update(origWordsList: WordsList, newName: String, newComment: String?, newWords: [Word]) {
		specificStorageService.update(origWordsList: origWordsList,
									  newName: newName,
									  newComment: newComment,
									  newWords: newWords)
	}

	func create(_ newWordsList: WordsList) {
		specificStorageService.create(newWordsList)
	}

	func deleteWordsList(name: String) {
		specificStorageService.deleteWordsList(name: name)
	}

	// MARK: - WordEditionStorageServiceProtocol

	func update(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void) {
		specificStorageService.update(origWord: origWord, newWordParts: newWordParts, completion: completion)
	}

	// MARK: - Private

	private func addDefaultWords(to words: [Word]) -> [Word] {
		let wordsDict: [String: Word] = words.reduce([String: Word]()) {
			var resultWordsArray = $0
			resultWordsArray[$1.foreign] = $1
			return resultWordsArray
		}

		let defaultWordsDict: [String: Word] = DefaultWordsList.wordsList.reduce([String: Word]()) {
			var resultWordsArray = $0
			resultWordsArray[$1.foreign] = $1
			return resultWordsArray
		}

		let allWords = wordsDict.merging(defaultWordsDict, uniquingKeysWith: { current, _ in current }).map { $0.value }
		if allWords.count != words.count {
			saveWords(allWords, completion: { _ in })
		}

		return allWords
	}
}
