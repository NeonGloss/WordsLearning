//
//  CDWordsList+extension.swift
//  WordsLearning
//
//  Created by Roman on 18/05/2023.
//

import CoreData

extension CDWordsList {

	/// Возвращает объект типа WordsList
	var wordsList: WordsList? {
		guard let name = name else { return nil }

		let wordsSet = (self.words as? Set<CDWord>) ?? []
		let words = Array(wordsSet).compactMap() { $0.word }

		return WordsList(name: name, commentString: self.comment, words: words)
	}

	/// Обновить свойства списка в CoreData
	/// - Parameters:
	///   - name: названиен списка
	///   - comment: коментарий
	///   - words: слова
	func update(withName name: String, comment: String?, words: [CDWord]) {
		let setOfNewCDWords = Set(words)
		self.name = name
		self.comment = comment
		self.words = setOfNewCDWords as NSSet

		managedObjectContext?.save(errorMSG: "📀💿❌ не удалось сохранить изменение списка слов в CoreData")
	}
}
