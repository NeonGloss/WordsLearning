import Foundation
import UIKit

struct Const {

    static let headerFont = UIFont(name: "Avenir-Light", size: 24) ?? .systemFont(ofSize: 24)
    static let middleFont = UIFont(name: "Avenir-Light", size: 20) ?? .systemFont(ofSize: 20)

    static let backgroundGradStartColor = UIColor(r: 31, g: 35, b: 62)
    static let backgroundGradEndColor = UIColor(r: 52, g: 61, b: 98)

    static let cellGradStartColor = UIColor(r: 46, g: 50, b: 80)
    static let cellGradEndColor = UIColor(r: 51, g: 58, b: 91)

    static let tableHeaderColor = UIColor(r: 46, g: 50, b: 80)

    static let customGreen = UIColor(r: 60, g: 208, b: 82)
    static let customRed = UIColor(r: 255, g: 68, b: 50)

    static let debugVisibility = false

	enum Sizes {
		static let textFieldHeight: CGFloat = 35
		static let horizontalIndent: CGFloat = 24
		static let verticalCellIndent: CGFloat = 15
		static let smallVerticalIndent: CGFloat = 12
	}
}

/// Артефакты нового дизайна
extension Const {

	enum Fonts {
		static let superHeader = UIFont(name: "Times New Roman", size: 30) ?? .systemFont(ofSize: 10)
		static let header = UIFont(name: "Times New Roman", size: 25) ?? .systemFont(ofSize: 10)
		static let normal = UIFont(name: "Thonburi", size: 18)?.bold() ?? .systemFont(ofSize: 5)
		static let small = UIFont(name: "Thonburi", size: 15) ?? .systemFont(ofSize: 5)
		static let tabBar =	UIFont(name: "Thonburi", size: 12) ?? .systemFont(ofSize: 5)
	}
}

extension UIColor {

	static let mainTextColor = UIColor.white

	/// Цвет серого легкого #989FAE

	/// Цвет желто-золотой  (hex = #FFB514)
	static let brandColor = UIColor(r: 255, g: 181, b: 20)

	/// Цвет оттенок синего 1
    static let brandDark = UIColor(r: 65, g: 74, b: 108)

	/// Цвет оттенок синего 2
	static let brandLight = UIColor(hex: "#323859")

	static let dsBackground0 = UIColor(hex: "#F9F3F0")
	static let dsBackground1 = UIColor(hex: "#333739")
	static let dsBrand = UIColor(hex: "#EB5E3D")
	static let dsBackground2 = UIColor(hex: "#41464A")
	static let dsNuance0 = UIColor(hex: "#444748")
	static let dsNuance1 = UIColor(hex: "#393D3D")
	static let dsBorder0 = UIColor(hex: "#979797")
	static let dsBorder1 = UIColor(hex: "#3F4344")
	static let dsProgressBar0 = UIColor(hex: "#848484")
	static let dsTextHighlighted = UIColor(hex: "#F0EBE8")
	static let dsTextNormal = UIColor(hex: "#8F908F")
	static let dsCheckboxBorder = UIColor(hex: "#484D4E")
	static let dsDeselectedButton = UIColor.clear
	static let dsSelectedButton = UIColor.dsBackground0
}
