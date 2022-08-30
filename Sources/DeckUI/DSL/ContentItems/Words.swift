//
//  Words.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Words: ContentItem {
    public enum Style {
        case title, subtitle, body, custom(Font)
        
        var font: Font {
            switch self {
            case .title:
                return Font.system(size: 60, weight: .bold, design: .default)
            case .subtitle:
                return Font.system(size: 40, weight: .light, design: .default)
            case .body:
                return Font.system(size: 30, weight: .regular, design: .default)
            case .custom(let font):
                return font
            }
        }
    }
    
    public let id = UUID()
    let text: String
    let style: Style
    
    public init(_ text: String, style: Style = .body) {
        self.text = text
        self.style = style
    }
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            Text(self.text)
                .font(self.style.font)
        )
    }
}
