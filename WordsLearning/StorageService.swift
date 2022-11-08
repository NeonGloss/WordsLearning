//
//  StorageService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 12.08.2022.
//

import Foundation

protocol SpecificStorageProtocol {

	/// Сохранить данные
	/// - Parameter data: данные
	/// - Parameter completion: замыкание с флагом успеха сохранения данных
	func saveData(_ data: Data, completion: (Bool) -> Void)

	/// Прочитать данные
	func readData() -> Data
}

/// Протокол сервиса хранения данных
protocol StorageServiceProtocol {

	/// Сохранить слова
	/// - Parameter list: список приложений партнеров
	func saveWords(_ words: [Word], completion: (Bool) -> Void)

	/// Прочитать слова
	/// - Parameter complition: блок кода выполняемый после загрузки данных
	func readWords(complition: @escaping ([Word]) -> ())
}

/// Сервис хранения данных
final class StorageService: StorageServiceProtocol {

	private var specificStorageService: SpecificStorageProtocol

	/// Инициализатор
	/// - Parameter specificStorage: сервис работы с памятью
	init(specificStorage: SpecificStorageProtocol) {
		specificStorageService = specificStorage
	}

	func saveWords(_ words: [Word], completion: (Bool) -> Void) {
		guard let data = try? JSONEncoder().encode(words) else { return }
		specificStorageService.saveData(data, completion: completion)
	}

	func readWords(complition: @escaping ([Word]) -> ()) {
		var resultedWords: [Word]
		let data = specificStorageService.readData()
		if let loadedWords = try? JSONDecoder().decode([Word].self, from: data) {
			resultedWords = addDefaultWords(to: loadedWords)
		} else {
			resultedWords = DefaultWordsList.wordsList
		}

		complition(resultedWords)
	}

	// MARK: Private

	private func addDefaultWords(to words: [Word]) -> [Word] {
		let wordsDict: [String: Word] = (words).reduce([String: Word]()) {
			var resultWordsArray = $0
			resultWordsArray[$1.foreign] = $1
			return resultWordsArray
		}

		let defaultWordsDict: [String: Word] = DefaultWordsList.wordsList.reduce([String: Word]()) {
			var resultWordsArray = $0
			resultWordsArray[$1.foreign] = $1
			return resultWordsArray
		}

		return wordsDict.merging(defaultWordsDict, uniquingKeysWith: { current, _ in current }).map { $0.value }
	}
}
