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
final class StorageService: StorageServiceProtocol {

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
