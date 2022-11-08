//
//  WordEditionService.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

// TODO: нужно добавить индекс в обхект Word и вынести функцию обновления слова в StorageService

/// Сервис
final class WordEditionService: WordStorageServiceProtocol {

	private let storageService: StorageServiceProtocol

	/// Инициализатор
	/// - Parameter storageService: сервис работы с хранением данных
	init(storageService: StorageServiceProtocol) {
		self.storageService = storageService
	}
	
	func updateWord(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void) {
		storageService.readWords { [weak self] currentWords in
			self?.updateSpecificWord(origWord: origWord, with: newWordParts, in: currentWords, completion: completion)
		}
	}

	// MARK: Private

	private func updateSpecificWord(origWord: Word,
									with newWordParts: EditedWordParts,
									in origWords: [Word],
									completion: (Bool) -> Void) {
		guard let index = origWords.firstIndex(of: origWord) else { return }

		let resultWords = origWords
		resultWords[index].update(with: newWordParts)
		storageService.saveWords(resultWords, completion: completion)
	}
}
