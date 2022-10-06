//
//  KeychainStorageService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 12.08.2022.
//

import Foundation

/// Класс хранилища данных
final class KeychainStorageService: SpecificStorageProtocol {

	private let keyToStore: String = "wordsForLearningKey"
	private let keychainWrapper: KeychainWrapperProtocol

	init(keychainWrapper: KeychainWrapperProtocol) {
		self.keychainWrapper = keychainWrapper
	}

	func saveData(_ data: Data, completion: (Bool) -> Void) {
		let isSuccess = keychainWrapper.save(key: keyToStore, data: data)
		completion(isSuccess == 0 ? true : false)
	}

	func readData() -> Data {
		keychainWrapper.load(key: keyToStore) ?? Data()
	}
}
