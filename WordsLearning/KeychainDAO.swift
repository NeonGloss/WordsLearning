//
//  KeychainDAO.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 12.08.2022.
//

import Foundation

/// Протокол сервиса хранения данных в keychain
protocol KeychainDAOProtocol: DAOProtocol {

	/// Сохранить данные
	/// - Parameter data: данные
	/// - Parameter completion: замыкание с флагом успеха сохранения данных
	func saveData(_ data: Data, completion: ((Bool) -> Void)?)

	/// Прочитать данные
	func readData() -> Data

	/// Удалить все данные
	func deleteData()
}

/// Класс хранилища данных
final class KeychainDAO: KeychainDAOProtocol {

	private let keyToStore: String = "wordsForLearningKey"
	private let keychainWrapper: KeychainWrapperProtocol

	/// Инициализатор
	/// - Parameter keychainWrapper: обертка над работой с keychain
	init(keychainWrapper: KeychainWrapperProtocol) {
		self.keychainWrapper = keychainWrapper
	}

	// MARK: - KeychainDAOProtocol

	func saveData(_ data: Data, completion: ((Bool) -> Void)?) {
		let isSuccess = keychainWrapper.save(key: keyToStore, data: data)
		completion?(isSuccess == 0 ? true : false)
	}

	func readData() -> Data {
		keychainWrapper.load(key: keyToStore) ?? Data()
	}

	func deleteData() {
		keychainWrapper.deleteData(forKey: keyToStore)
	}

	// MARK: - DAOProtocol

	func saveWords(_ words: [Word], completion: ((Bool) -> Void)?) {
		guard let data = try? JSONEncoder().encode(words) else { return }
		saveData(data, completion: completion)
	}

	func loadWords(complition: @escaping ([Word]) -> ()) {
		let data = readData()
		let loadedWords = try? JSONDecoder().decode([Word].self, from: data)
		complition(loadedWords ?? [])
	}

	func loadWordsLists() -> [WordsList] {
		fatalError("Keychain should not be used for this")
	}

	func create(_ newWordsList: WordsList) {
		fatalError("Keychain should not be used for this")
	}

	func deleteWordsList(name: String) {
		fatalError("Keychain should not be used for this")
	}

	func update(origWordsList: WordsList, newName: String, newComment: String?, newWords: [Word]) {
		fatalError("Keychain should not be used for this")
	}

	func update(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void) {
		fatalError("Keychain should not be used for this")
	}
}
