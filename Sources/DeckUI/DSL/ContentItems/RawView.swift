//
//  RawView.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct RawView<Content: View>: ContentItem {
    public let id = UUID()
    
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            self.content
        )
    }
}
