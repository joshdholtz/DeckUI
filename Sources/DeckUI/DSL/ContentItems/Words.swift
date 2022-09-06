//
//  Words.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Words: ContentItem {
    public let id = UUID()
    let text: String
    let color: Color?
    let font: Font?
    
    public init(_ text: String, color: Color? = nil, font: Font? = nil) {
        self.text = text
        self.color = color
        self.font = font
    }
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        AnyView(
            Text(self.text)
                .font(self.font ?? theme.body.font)
                .foregroundColor(self.color ?? theme.body.color)
        )
    }
}
