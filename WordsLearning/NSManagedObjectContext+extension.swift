//
//  NSManagedObjectContext+extension.swift
//  WordsLearning
//
//  Created by Roman on 16/05/2023.
//

import CoreData

extension NSManagedObjectContext {

	/// Сохранение контекста
	/// - Parameter msg: сообщение для консоли при ошибке сохранения
	func save(errorMSG msg: String = "📀💿❌") {
		do {
			try self.save()
		} catch let error {
			print(msg, error)
		}
	}

	func fetchAllEntities<T:NSManagedObject>(ofType: T.Type) -> [T] {
		var fetchedObjects: [NSFetchRequestResult] = []
		let fetchRequest = T.fetchRequest()
		do {
			fetchedObjects = try self.fetch(fetchRequest)
		} catch let error {
			print(error)
		}
		return (fetchedObjects as? [T]) ?? []
	}
}
