//
//  WordsList.swift
//  WordsLearning
//
//  Created by Roman on 18/05/2023.
//

/// Список слов для изучения
final class WordsList {

	/// Название
	var name: String

	/// Массив слов
	var words: [Word]

	/// Комментарий
	var commentString: String?

	/// Инициализатор
	/// - Parameters:
	///   - name: название
	///   - commentString: комментарий
	///   - words: массив слов
	init(name: String, commentString: String? = nil, words: [Word] = []) {
		self.name = name
		self.words = words
		self.commentString = commentString
	}
}
