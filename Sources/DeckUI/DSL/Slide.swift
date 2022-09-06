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
    let theme: Theme?
    @ContentItemArrayBuilder var contentItems: () -> [ContentItem]
    
    public init(alignment: Alignment = .topLeading, padding: CGFloat = 40, comment: String? = nil, theme: Theme? = nil, @ContentItemArrayBuilder contentItems: @escaping () -> [ContentItem]) {
        self.alignment = alignment
        self.horizontalAlignment = .leading
        self.padding = padding
        self.comment = comment
        self.theme = theme
        self.contentItems = contentItems
    }
    
    func buildContentItems(theme: Theme) -> AnyView {
        let contentViews = contentItems()
        return AnyView(
            ForEach(contentViews, id: \.id) {
                $0.view
            }
        )
    }
    
    func buildView(theme: Theme) -> AnyView {
        let themeToUse = self.theme ?? theme
        
        let contentItemViews = self.buildContentItems(theme: themeToUse)
        
        return AnyView(
            VStack(alignment: self.horizontalAlignment) {
                contentItemViews
            }
            .padding(self.padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: self.alignment)
            .background(themeToUse.background)
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
