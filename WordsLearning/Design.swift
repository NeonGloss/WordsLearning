//
//  Design.swift
//  WordsLearning
//
//  Created by Roman on 15/05/2023.
//

import UIKit

// Элементы дизайна
struct Design {
    
    enum Colors {
		static let gradientBackground0Top = UIColor(hex: "#237A57")
		static let gradientBackground0Bottom = UIColor(hex: "#093028")
        static let background0 = UIColor(hex: "#F9F3F0")
        static let background1 = UIColor(hex: "#d1701b")
        static let dsBackground1 = UIColor(hex: "#333739")
        static let dsBrand = UIColor(hex: "#EB5E3D")
        static let dsBackground2 = UIColor(hex: "#41464A")
        static let dsNuance0 = UIColor(hex: "#238A5F")
        static let dsNuance1 = UIColor(hex: "#393D3D")
        static let dsBorder0 = UIColor(hex: "#979797")
        static let dsBorder1 = UIColor(hex: "#3F4344")
        static let dsProgressBar0 = UIColor(hex: "#848484")
        static let dsTextHighlighted = UIColor(hex: "#F0EBE8")
        static let dsTextNormal = UIColor(hex: "#8F908F")
        static let dsCheckboxBorder = UIColor(hex: "#484D4E")
        static let dsDeselectedButton = UIColor.clear
    }
    
    enum Fonts {
        static let superHeader = UIFont(name: "Times New Roman", size: 30) ?? .systemFont(ofSize: 10)
        static let header = UIFont(name: "Times New Roman", size: 25) ?? .systemFont(ofSize: 10)
        static let normal = UIFont(name: "Thonburi", size: 18)?.bold() ?? .systemFont(ofSize: 5)
        static let small = UIFont(name: "Thonburi", size: 15) ?? .systemFont(ofSize: 5)
        static let smallest = UIFont(name: "Thonburi", size: 13) ?? .systemFont(ofSize: 5)
    }
}
