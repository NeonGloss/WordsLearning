//
//  UITableView+extension.swift
//  DailyResults
//
//  Created by Roman Kuzin on 26.02.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

extension UITableView {

	func registerCellOfType<T: UITableViewCell>(_ cellType: T.Type) where T: HasCellId {
		self.register(cellType.self, forCellReuseIdentifier: cellType.getCellReuseIdentifier())
	}

	func registerHederFooterOfType<T: UITableViewHeaderFooterView>(_ cellType: T.Type) where T: HasCellId {
		self.register(cellType.self, forHeaderFooterViewReuseIdentifier: cellType.cellId)
	}

	func dequeuedCellOfType<T: UITableViewCell> (_ cellType: T.Type) -> T? where T: HasCellId {
		self.dequeueReusableCell(withIdentifier: cellType.getCellReuseIdentifier()) as? T
	}

	func dequeuedCellOfType<T: UITableViewCell> (_ cellType: T.Type, for indexPath: IndexPath) -> T? where T: HasCellId {
		self.dequeueReusableCell(withIdentifier: cellType.getCellReuseIdentifier(), for: indexPath) as? T
	}

	func dequeuedHederFooterOfType<T: UITableViewHeaderFooterView>(_ cellType: T.Type) -> T?  where T: HasCellId {
		self.dequeueReusableHeaderFooterView(withIdentifier: cellType.cellId) as? T
	}

	func registerCellOfType<T: UITableViewCell>(_ cellType: T.Type) {
		self.register(cellType.self, forCellReuseIdentifier: cellType.getCellReuseIdentifier())
	}

	func dequeuedCellOfType<T: UITableViewCell> (_ cellType: T.Type) -> T? {
		self.dequeueReusableCell(withIdentifier: cellType.getCellReuseIdentifier()) as? T
	}
}

extension UITableViewCell {

	static func getCellReuseIdentifier() -> String {
		return "CustomCell_\(self.description())"
	}
}
