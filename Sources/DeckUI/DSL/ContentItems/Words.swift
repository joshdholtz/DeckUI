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
    let attributedText: AttributedString?
    
    public init(_ text: String, color: Color? = nil, font: Font? = nil, markdown: Bool = false) {
        if let markdown = try? AttributedString(markdown: text) {
            self.attributedText = markdown
            self.text = String(markdown.characters)
        } else {
            self.text = text
            self.attributedText = nil
        }
        self.color = color
        self.font = font
    }
    
    public init(_ attributedText: AttributedString, color: Color? = nil, font: Font? = nil) {
        self.text = String(attributedText.characters)
        self.color = color
        self.font = font
        self.attributedText = attributedText
    }
    
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        AnyView(
            ((attributedText != nil) ? Text(self.attributedText!) : Text(self.text))
                .font(self.font ?? theme.body.font)
                .foregroundColor(self.color ?? theme.body.color)
        )
    }
}
