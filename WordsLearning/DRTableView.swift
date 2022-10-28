//
//  DRTableView.swift
//  DailyResults
//
//  Created by Roman Kuzin on 18.07.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

final class DRTableView: UITableView {

	/// Элементы(ячейки) для отображения
	public var items = [DRTableViewCellProtocol]() {
		didSet {
			items.forEach { registerCellOfType(type(of: $0).self) }
			reloadData()
		}
	}

	init(frame: CGRect) {
		super.init(frame: frame, style: .plain)
		delegate = self
		dataSource = self
		separatorStyle = .none
		backgroundColor = .clear
		rowHeight = UITableView.automaticDimension
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private

	private func setup() {
		let tapOnEmptySpace = UITapGestureRecognizer(target: self, action: #selector(tableWasTapped))
		backgroundView = UIView()
		backgroundView?.addGestureRecognizer(tapOnEmptySpace)
	}

	@objc private func tableWasTapped() {
		visibleCells.forEach {
			($0 as? DRTableViewCellProtocol)?.emptySpaceOnTableWasTapped()
		}
	}
}

extension DRTableView: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = items[indexPath.row]
		var cell: UITableViewCell
		if item.shouldReuse {
			cell = tableView.dequeuedCellOfType(type(of: item)) ?? UITableViewCell()
		} else {
			cell = item
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		let cell = tableView.cellForRow(at: indexPath) as? DRTableViewCellProtocol
		cell?.didSelected()
		tableView.beginUpdates()
		tableView.setNeedsDisplay()
		tableView.endUpdates()
		tableView.cellForRow(at: indexPath)?.isSelected = false

		tableView.visibleCells.forEach {
			($0 as? DRTableViewCellProtocol)?.someCellWasSelected()
		}
	}
}
