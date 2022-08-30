//
//  Slide.swift
//  DeckUI (iOS)
//
//  Created by Josh Holtz on 8/28/22.
//

import SwiftUI

public struct Slide: Identifiable {
    public let id = UUID()
    
    let alignment: Alignment
    let horizontalAlignment: HorizontalAlignment
    let padding: CGFloat
    let comment: String?
    @ContentItemArrayBuilder var contentItems: () -> [ContentItem]
    
    public init(alignment: Alignment = .topLeading, padding: CGFloat = 40, comment: String? = nil, @ContentItemArrayBuilder contentItems: @escaping () -> [ContentItem]) {
        self.alignment = alignment
        self.horizontalAlignment = .leading
        self.padding = padding
        self.comment = comment
        self.contentItems = contentItems
    }
    
    var things: [ContentItem] {
        return contentItems()
    }
    
    var thing: AnyView {
        return AnyView(
            ForEach(self.things, id: \.id) {
                $0.view
            }
        )
    }
    
    var view: AnyView {
        return AnyView(
            VStack(alignment: self.horizontalAlignment) {
                thing
            }
            .padding(self.padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: self.alignment)
        )
    }
}

@resultBuilder
public enum SlideArrayBuilder {
    public static func buildEither(first component: [Slide]) -> [Slide] {
        return component
    }
    
    public static func buildEither(second component: [Slide]) -> [Slide] {
        return component
    }
    
    // Might only need this one
    public static func buildBlock(_ components: [Slide]...) -> [Slide] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [Slide]?) -> [Slide] {
        return component ?? []
    }
    
    // Might only need this one
    public static func buildExpression(_ expression: Slide) -> [Slide] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: Void) -> [Slide] {
        return []
    }
}
