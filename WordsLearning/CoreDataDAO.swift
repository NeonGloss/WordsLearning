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
	}

	func readWords(complition: @escaping ([Word]) -> ()) {
		let loadedCDWords = context.fetchAllEntities(ofType: CDWord.self)
		let loadedWords = loadedCDWords.compactMap { $0.word }
		complition(loadedWords)
	}
}
