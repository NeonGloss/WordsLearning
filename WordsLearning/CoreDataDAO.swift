//
//  CoreDataDAO.swift
//  WordsLearning
//
//  Created by Roman on 16/05/2023.
//

import UIKit
import CoreData

/// Объект доступа к даннм, сохраненных в CoreData
final class CoreDataDAO: DAOProtocol {

	private var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext ??
						  NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

	func saveWords(_ words: [Word], completion: ((Bool) -> Void)?) {
		let loadedCDWords = context.fetchAllEntities(ofType: CDWord.self)

		words.forEach { word in
			let cdWord = loadedCDWords.first(where: { $0.foreign == word.foreign } ) ?? CDWord(context: context)
			cdWord.update(with: word)
		}
		completion?(true)
	}

	func loadWords(complition: @escaping ([Word]) -> ()) {
		let loadedCDWords = context.fetchAllEntities(ofType: CDWord.self)
		let loadedWords = loadedCDWords.compactMap { $0.word }
		complition(loadedWords)
	}

	func create(_ newWordsList: WordsList) {
		let cdWordsList = CDWordsList(context: context)
		let cdWords = context.fetchAllEntities(ofType: CDWord.self).filter { cdWord in
			newWordsList.words.contains(where: { $0.foreign == cdWord.foreign})
		}
		cdWordsList.update(withName: newWordsList.name, comment: newWordsList.commentString, words: cdWords)
	}
	
	func update(origWordsList: WordsList, newName: String, newComment: String?, newWords: [Word]) {
		let cdList = context.fetchAllEntities(ofType: CDWordsList.self).first() { $0.name == origWordsList.name}
		let cdWords = context.fetchAllEntities(ofType: CDWord.self).filter { cdWord in
			newWords.contains(where: { $0.foreign == cdWord.foreign})
		}
		cdList?.update(withName: newName, comment: newComment, words: cdWords)
	}

	func update(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void) {
		let cdWord = context.fetchAllEntities(ofType: CDWord.self).first { $0.foreign == origWord.foreign }
		guard let cdWord = cdWord else {
			completion(false)
			return
		}

		let newWord = Word(foreign: newWordParts.foreign,
						   native: newWordParts.native,
						   transcription: newWordParts.transcription)

		cdWord.update(with: newWord)
		completion(true)
	}

	func loadWordsLists() -> [WordsList] {
		let loadedCDWordsLists = context.fetchAllEntities(ofType: CDWordsList.self)
		let loadedWordsLists = loadedCDWordsLists.compactMap() { $0.wordsList }
		return loadedWordsLists
	}

	func deleteWordsList(name: String) {
		let cdWordsList = context.fetchAllEntities(ofType: CDWordsList.self)
		let cdListForDeletion = cdWordsList.first() { $0.name == name }
		guard let cdListForDeletion = cdListForDeletion else { return }
		context.delete(cdListForDeletion)
	}
}
