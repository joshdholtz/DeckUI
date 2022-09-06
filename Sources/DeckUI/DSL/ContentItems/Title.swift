//
//  Title.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Title: ContentItem {
    public let id = UUID()
    let title: String
    let subtitle: String?
    
    public init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        return AnyView(
            // TODO: Fix hardcoding of alignment
            VStack(alignment: .leading, spacing: 0) {
                Text(self.title)
                    .font(theme.title.font)
                    .foregroundColor(theme.title.color)
                
                if let subtitle = self.subtitle {
                    Text(subtitle)
                        .font(theme.subtitle.font)
                        .foregroundColor(theme.subtitle.color)
                }
            }.padding(.bottom, 20)
        )
    }
}
