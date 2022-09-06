//
//  ContentItem.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/28/22.
//

import SwiftUI

public protocol ContentItem {
    var id: UUID { get }
    func buildView(theme: Theme) -> AnyView
}

@resultBuilder
public enum ContentItemArrayBuilder {
    public static func buildBlock(_ components: [ContentItem]...) -> [ContentItem] {
        return components.flatMap { $0 }
    }
    
    public static func buildExpression(_ expression: ContentItem) -> [ContentItem] {
        return [expression]
    }
}
