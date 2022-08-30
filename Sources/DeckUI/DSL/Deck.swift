//
//  Deck.swift
//  DeckUI (iOS)
//
//  Created by Josh Holtz on 8/28/22.
//

import Foundation

public struct Deck {
    let title: String
    @SlideArrayBuilder var slides: () -> [Slide]
    
    public init(title: String, @SlideArrayBuilder slides: @escaping () -> [Slide]) {
        self.title = title
        self.slides = slides
    }
}
