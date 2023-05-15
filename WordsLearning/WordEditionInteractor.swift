//
//  WordEditionInteractor.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 30.08.2022.
//  Copyright © 2022 Roman Kuzin. All rights reserved.
//

typealias EditedWordParts = (transcription: String,
							 native: [String],
							 fToNRemark: String?,
							 nToFRemark: String?,
							 foreign: String)

protocol WordStorageServiceProtocol {

	/// Пересохранить слово с изменениями
	/// - Parameters:
	///   - origWord: изначальное слово
	///   - newWordParts: новые свойства слова
	///   - completion: замыкание, возвращает true - если изменения сохранились успешно
	func updateWord(origWord: Word, newWordParts: EditedWordParts, completion: @escaping (Bool) -> Void)
}

/// Протокол интерактора сцены
protocol WordEditionInteractorProtocol {

	func viewDidLoad()

	func saveButtonTapped()

	func transcriptionChanged(to: String)

	func foreignChanged(to: String)

	func nativeChanged(to: String)

	func fToNRemarkChanged(to: String?)

	func nToFRemarkChanged(to: String?)
}

/// Интерактор сцены
final class WordEditionInteractor: WordEditionInteractorProtocol {

	/// Презентер сцены
	var presenter: WordEditionPresenterProtocol?

	private var storageService: WordStorageServiceProtocol
	private let actionOnClose: (EditedWordParts?) -> Void
	private var editedTranscription: String
	private var editedFToNRemark: String?
	private var editedNtoFRemark: String?
	private var editedForeign: String
	private var editedNative: [String]
	private var origWord: Word

    /// Инициализатор
    /// - Parameters:
    ///   - storageService: сервис работы с хранилищем
    ///   - word: словов для изменения
    ///   - actionOnClose: замыкание, которое будет выполненно при закрытии экрана
	init(storageService: WordStorageServiceProtocol, word: Word, actionOnClose: @escaping (EditedWordParts?) -> Void) {
		self.storageService = storageService
		self.actionOnClose = actionOnClose
		self.origWord = word

		editedTranscription = word.transcription
		editedFToNRemark = word.fToNRemark
		editedNtoFRemark = word.nToFRemark
		editedForeign = word.foreign
		editedNative = word.native
	}

	func saveButtonTapped() {
		let parts = (editedTranscription, editedNative, editedFToNRemark, editedNtoFRemark, editedForeign)
		storageService.updateWord(origWord: origWord, newWordParts: parts) { [weak self] isSuccess in
			self?.actionOnClose(isSuccess ? parts : nil)
			self?.presenter?.dismissScene()
		}
	}

	func viewDidLoad() {
		presenter?.fillUIWith(origWord)
	}

	func transcriptionChanged(to newValue: String) {
		editedTranscription = newValue
	}

	func foreignChanged(to newValue: String) {
		editedForeign = newValue
	}

	func nativeChanged(to newValue: String) {
		editedNative = newValue.components(separatedBy: ",")
	}

	func fToNRemarkChanged(to newValue: String?) {
		editedFToNRemark = newValue
	}

	func nToFRemarkChanged(to newValue: String?) {
		editedNtoFRemark = newValue
	}
}
