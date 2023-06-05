//
//  Columns.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Columns: ContentItem {
    public let id = UUID()
    @ColumnArrayBuilder var columns: () -> [Column]
    
    public init(@ColumnArrayBuilder columns: @escaping () -> [Column]) {
        self.columns = columns
    }
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        AnyView(
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(self.columns().enumerated()), id: \.offset) { index, column in
                        // TODO: dont love this hardcoded
                        VStack(alignment: .leading) {
                            column.buildView(theme: theme)
                        }.padding(.trailing, 20)
                            .frame(width: proxy.size.width / CGFloat(self.columns().count), alignment: .leading)
                    }
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
}

public struct Column: Identifiable {
    public let id = UUID()
    public let theme: Theme?
    
    @ContentItemArrayBuilder var contentItems: () -> [ContentItem]
    
    public func buildView(theme: Theme) -> AnyView {
        let contentItemViews = contentItems()
        return AnyView(
            ForEach(contentItemViews, id: \.id) {
                $0.buildView(theme: theme)
            }
        )
    }
    
    public init(theme: Theme? = nil, @ContentItemArrayBuilder contentItems: @escaping () -> [ContentItem]) {
        self.theme = theme
        self.contentItems = contentItems
    }
}

@resultBuilder
public enum ColumnArrayBuilder {
    public static func buildEither(first component: [Column]) -> [Column] {
        return component
    }
    
    public static func buildEither(second component: [Column]) -> [Column] {
        return component
    }
    
    // Might only need this one
    public static func buildBlock(_ components: [Column]...) -> [Column] {
        return components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [Column]?) -> [Column] {
        return component ?? []
    }
    
    // Might only need this one
    public static func buildExpression(_ expression: Column) -> [Column] {
        return [expression]
    }
    
    public static func buildExpression(_ expression: Void) -> [Column] {
        return []
    }
    
    public static func buildExpression(_ expression: [Column]) -> [Column] {
        return expression
    }
    
    public static func buildArray(_ components: [[Column]]) -> [Column] {
        return components.flatMap { $0 }
    }
}
