//
//  WordsSelectionPresenter.swift
//  WordsLearning
//
//  Created by Roman Kuzin on 15/03/2023.
//  Copyright © 2023 Roman Kuzin. All rights reserved.
//

/// Протокол презентера сцены выбора слов для изучения
protocol WordsListsSelectionPresenterProtocol {

	/// Отобразить элементы таблицы
	/// - Parameters:
	///  - items: элементы таблицы
	///  - title: текст заголовка
	func present(_ items: [DRTableViewCellProtocol], title: String)

	/// Обновить заголовочный текст
	/// - Parameter newValue: текст
	func updateTitleText(to newValue: String)

	/// Отобразить запрос на подтверждение удаление списка
	/// - Parameter name: название списка
	/// - Parameter completion: замыкание, возвращает флаг подтверждения удаления списка
	func presentListDeletionConfirmation(withName name: String, completion: @escaping (Bool) -> Void)
	
	/// Закрыть сцену
	func closeScene()
}

/// Презентер сцены выбора слов для изучения
final class WordsListsSelectionPresenter: WordsListsSelectionPresenterProtocol {
	
	private weak var viewController: WordsListsSelectionViewControllerProtocol?
	private var currentItems: [DRTableViewCellProtocol]
	private let alertService: AlertServiceProtocol
	
	/// Инициализатор
	/// - Parameters:
	///  - viewController: вью-контроллер сцены
	///  - alertService: сервис отображения алертов
	init(viewController: WordsListsSelectionViewControllerProtocol, alertService: AlertServiceProtocol) {
		self.viewController = viewController
		self.alertService = alertService
		currentItems = []
	}
	
	func present(_ items: [DRTableViewCellProtocol], title: String) {
		currentItems = items
		viewController?.displayItems(items)
		viewController?.setTitleTextTo(title)
	}

	func updateTitleText(to newValue: String) {
		viewController?.setTitleTextTo(newValue)
	}

	func presentListDeletionConfirmation(withName name: String, completion: @escaping (Bool) -> Void) {
		guard let viewController = viewController else { return }

		let cancelButton = ButtonSettins(title: "Отмена") {
			completion(false)
		}
		let asseptButton = ButtonSettins(title: "Да") {
			completion(true)
		}
		alertService.showRichAlert(over: viewController,
								   image: SemanticImages.questionMarkCircleFill.coloredAs(.white, .orange),
								   title: "Точно удалить список с названием:",
								   subtitle: name,
								   buttonsSettings: [cancelButton, asseptButton])
	}
	
	func closeScene() {
		viewController?.closeScene()
	}
}
