//
//  CodeTheme.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import Splash
import SwiftUI

public struct CodeTheme {
    public var font: SwiftUI.Font
    public var plainTextColor: SwiftUI.Color
    public var backgroundColor: SwiftUI.Color
    public var tokenColors: [TokenType: SwiftUI.Color]
}

extension CodeTheme {
    func text(for code: CodeComponent) -> some View {
        let font = font
        let backgroundColor = backgroundColor
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
        
        return Text(text)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .font(font)
    }
}
