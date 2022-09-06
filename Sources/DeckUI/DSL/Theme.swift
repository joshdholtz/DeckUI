//
//  Theme.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/5/22.
//

import SwiftUI

public struct Theme {
    var background: Color
    var title: Foreground
    var subtitle: Foreground
    var body: Foreground
}

public struct Foreground {
    let color: Color
    let font: Font
}

extension Theme {
    public static let standard: Theme = .dark
    
    public static let dark: Theme = Theme(
        background: Color(hex: "#221d29"),
        title: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 60, weight: .bold, design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 35, weight: .light, design: .default)
        ),
        body: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 30, weight: .regular, design: .default)
        )
    )
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
