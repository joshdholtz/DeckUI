//
//  Bullets.swift
//  DeckUI
//
//  Created by Josh Holtz on 9/1/22.
//

import SwiftUI

public struct Bullets: ContentItem {
    public enum Style {
        case bullet
        case dash
        
        var display: String {
            switch self {
            case .bullet:
                return "•"
            case .dash:
                return "–"
            }
        }
    }
    
    public let id = UUID()
    let style: Style
    @WordArrayBuilder var words: () -> [Words]
    
    public init(style: Style = .bullet, @WordArrayBuilder words: @escaping () -> [Words]) {
        self.style = style
        self.words = words
    }
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            // TODO: Not sure if hardocing leading here is great
            VStack(alignment: .leading, spacing: 10) {
                ForEach(self.words(), id:\.id) { word in
                    HStack(alignment: .center, spacing: 10) {
                        Words(self.style.display, style: word.style).view
                        word.view
                    }
                }
            }
        )
    }
}

@resultBuilder
public enum WordArrayBuilder {
    public static func buildEither(first component: [Words]) -> [Words] {
        return component
    }
    
    public static func buildEither(second component: [Words]) -> [Words] {
        return component
    }
    
    // Might only need this one
    public static func buildBlock(_ components: [Words]...) -> [Words] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [Words]?) -> [Words] {
        return component ?? []
    }
    
    // Might only need this one
    public static func buildExpression(_ expression: Words) -> [Words] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: Void) -> [Words] {
        return []
    }
}
