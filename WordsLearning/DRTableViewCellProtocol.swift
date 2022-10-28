//
//  DRTableViewCellProtocol.swift
//  DailyResults
//
//  Created by 18371200 on 28.10.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

/// Протокол ячейки
protocol DRTableViewCellProtocol: UITableViewCell {

	/// Флаг возможности переиспользовать ячейку
	var shouldReuse: Bool { get }

	/// Вызывается когда ячейка была нажата пользователем
	func didSelected()

	/// Сообщает что какая-то ячейка была нажата
	func someCellWasSelected()

	/// Сообщает что таблица была нажата на пустом месте
	func emptySpaceOnTableWasTapped()
}
