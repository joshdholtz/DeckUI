//
//  Deck.swift
//  DeckUI (iOS)
//
//  Created by Josh Holtz on 8/28/22.
//

import Foundation

public struct Deck {
    let title: String
    let theme: Theme
    @SlideArrayBuilder var slides: () -> [Slide]

    public var slideCount: Int {
        slides().count
    }
    
    public init(title: String, theme: Theme = .dark, @SlideArrayBuilder slides: @escaping () -> [Slide]) {
        self.title = title
        self.theme = theme
        self.slides = slides
    }
}
