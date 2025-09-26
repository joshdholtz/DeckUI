//
//  CodeTheme.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import SwiftUI

public struct CodeTheme {
    public var font: SwiftUI.Font
    public var plainTextColor: SwiftUI.Color
    public var backgroundColor: SwiftUI.Color
    public var tokenColors: [TokenType: SwiftUI.Color]

    public init(font: SwiftUI.Font, plainTextColor: SwiftUI.Color, backgroundColor: SwiftUI.Color, tokenColors: [TokenType : SwiftUI.Color]) {
        self.font = font
        self.plainTextColor = plainTextColor
        self.backgroundColor = backgroundColor
        self.tokenColors = tokenColors
    }
}

extension CodeTheme {
    func text(for code: CodeComponent) -> AttributedString {
        let foregroundColor: SwiftUI.Color
        let text: String
        
        switch code {
        case .token(let string, let token):
            foregroundColor = tokenColors[token] ?? plainTextColor
            text = string
        case .plainText(let string):
            foregroundColor = plainTextColor
            text = string
        case .whitespace(let string):
            foregroundColor = plainTextColor
            text = string
        }

        var attrString = AttributedString(stringLiteral: text)
        attrString.font = font
        attrString.backgroundColor = backgroundColor
        attrString.foregroundColor = foregroundColor

        return attrString
    }
}

extension CodeTheme {
    public static let xcodeDark: CodeTheme = CodeTheme(
        font: Font.system(size: 22, weight: .regular, design: .monospaced),
        plainTextColor: Color(hex: "#FFFFFF"),
        backgroundColor: .clear,
        tokenColors: [
            .keyword:       Color(hex: "#ff79b3"),
            .string:        Color(hex: "#ff8170"),
            .type:          Color(hex: "#dabaff"),
            .call:          Color(hex: "#78c2b4"),
            .number:        Color(hex: "#dac87c"),
            .comment:       Color(hex: "#808b98"),
            .property:      Color(hex: "#79c2b4"),
            .dotAccess:     Color(hex: "#79c2b4"),
            .preprocessing: Color(hex: "#ffa14f")
        ]
    )

    public static let xcodeLight: CodeTheme = CodeTheme(
        font: Font.system(size: 22, weight: .regular, design: .monospaced),
        plainTextColor: Color(hex: "#000000"),
        backgroundColor: .clear,
        tokenColors: [
            .keyword:       Color(hex: "#9b2393"),
            .string:        Color(hex: "#d12f1b"),
            .type:          Color(hex: "#703daa"),
            .call:          Color(hex: "#3e8087"),
            .number:        Color(hex: "#272ad8"),
            .comment:       Color(hex: "#5d6c79"),
            .property:      Color(hex: "#3e8087"),
            .dotAccess:     Color(hex: "#3e8087"),
            .preprocessing: Color(hex: "#78492a")
        ]
    )
}
