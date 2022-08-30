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
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            GeometryReader { proxy in
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(self.columns().enumerated()), id: \.offset) { index, column in
                        // TODO: dont love this hardcoded
                        VStack(alignment: .leading) {
                            column.thing
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
    
    @ContentItemArrayBuilder var contentItems: () -> [ContentItem]
    
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
    
    public init(@ContentItemArrayBuilder contentItems: @escaping () -> [ContentItem]) {
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
}
