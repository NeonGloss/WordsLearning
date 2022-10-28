//
//  HasCellIdProtocol.swift
//  DailyResults
//
//  Created by Roman Kuzin on 26.02.2021.
//  Copyright © 2021 Roman Kuzin. All rights reserved.
//

import UIKit

protocol HasCellId: UIView {

	static var cellId: String { get }
}
