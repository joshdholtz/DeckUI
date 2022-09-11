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
    
    var code: CodeTheme
    var codeHighlighted: CodeTheme
    
    public init(background: Color, title: Foreground, subtitle: Foreground, body: Foreground, code: Foreground, codeHighlighted: (Color, Foreground)) {
        self.background = background
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.code = CodeTheme(font: code.font, plainTextColor: code.color, backgroundColor: .clear, tokenColors: [:])
        self.codeHighlighted = CodeTheme(font: codeHighlighted.1.font, plainTextColor: codeHighlighted.1.color, backgroundColor: codeHighlighted.0, tokenColors: [:])
    }
    
    public init(background: Color, title: Foreground, subtitle: Foreground, body: Foreground, code: CodeTheme, codeHighlighted: (Color, Foreground)) {
        self.background = background
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.code = code
        self.codeHighlighted = CodeTheme(font: codeHighlighted.1.font, plainTextColor: codeHighlighted.1.color, backgroundColor: codeHighlighted.0, tokenColors: [:])
    }
    
    public init(background: Color, title: Foreground, subtitle: Foreground, body: Foreground, code: CodeTheme, codeHighlighted: CodeTheme) {
        self.background = background
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.code = code
        self.codeHighlighted = codeHighlighted
    }
}

public struct Foreground {
    let color: Color
    let font: Font
    
    public init(color: Color, font: Font) {
        self.color = color
        self.font = font
    }
}

extension Theme {
    public static let standard: Theme = .black
    
    public static let dark: Theme = Theme(
        background: Color(hex: "#221d29"),
        title: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 80, weight: .bold, design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 40, weight: .light, design: .default).italic()
        ),
        body: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 40, weight: .regular, design: .default)
        ),
        code: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 22, weight: .regular, design: .monospaced)
        ),
        codeHighlighted: (Color(hex: "#000000"), Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 22, weight: .heavy, design: .monospaced)
        ))
    )
    
    public static let black: Theme = Theme(
        background: Color(hex: "#000000"),
        title: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 80, weight: .bold, design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 50, weight: .light, design: .default).italic()
        ),
        body: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 40, weight: .regular, design: .default)
        ),
        code: Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 22, weight: .regular, design: .monospaced)
        ),
        codeHighlighted: (Color(hex: "#CCCCCC"), Foreground(
            color: Color(hex: "#000000"),
            font: Font.system(size: 22, weight: .heavy, design: .monospaced)
        ))
    )
    
    public static let white: Theme = Theme(
        background: Color(hex: "#FFFFFF"),
        title: Foreground(
            color: Color(hex: "#000000"),
            font: Font.system(size: 80, weight: .bold, design: .default)
        ),
        subtitle: Foreground(
            color: Color(hex: "#000000"),
            font: Font.system(size: 40, weight: .light, design: .default).italic()
        ),
        body: Foreground(
            color: Color(hex: "#000000"),
            font: Font.system(size: 40, weight: .regular, design: .default)
        ),
        code: Foreground(
            color: Color(hex: "#000000"),
            font: Font.system(size: 22, weight: .regular, design: .monospaced)
        ),
        codeHighlighted: (Color(hex: "#000000"), Foreground(
            color: Color(hex: "#FFFFFF"),
            font: Font.system(size: 22, weight: .heavy, design: .monospaced)
        ))
    )
}

public extension Color {
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
