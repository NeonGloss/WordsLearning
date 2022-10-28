//
//  PlainCell.swift
//  DailyResults
//
//  Created by Roman Kuzin on 19.07.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

final class PlainCell: UITableViewCell, DRTableViewCellProtocol {
	var shouldReuse = false

	init(title: String?) {
		super.init(style: .subtitle, reuseIdentifier: nil)
		textLabel?.text = title
		backgroundColor = .orange
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

	func didSelected() {}

	func someCellWasSelected() {}

	func emptySpaceOnTableWasTapped() {}
}
