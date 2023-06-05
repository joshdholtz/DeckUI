//
//  PresentationState.swift
//  
//
//  Created by Zachary Brass on 3/12/23.
//

import SwiftUI

open class PresentationState: ObservableObject {
    static let shared = PresentationState()
    @Published var slideIndex = 0
    
    var loop = false
    var slideTransition: SlideTransition? = .horizontal
    
    @Published var activeTransition: AnyTransition = .slideFromTrailing
    
    // Putting in sample Deck in case the user doesn't assign one. It instructs the user on how to add a Deck of their own
    open var deck: Deck = Deck(title: "DeckUI Example") {
            Slide(alignment: .center, comment: "Presenter notes are passed into the comment argument in the init method each of Slide") {
                Title("DeckUI Example")
            }
            
            Slide(alignment: .center) {
                Title("Getting Started")
                Columns {
                    Column {
                        Code(.swift) {
                        """
                        import SwiftUI
                        import DeckUI
                        
                        struct ContentView: View {
                            var body: some View {
                                Presenter(deck: self.deck)
                            }
                        }

                        extension ContentView {
                            var deck: Deck {
                                Deck(title: "SomeConf 2023") {
                                    Slide(alignment: .center) {
                                        Title("Welcome to DeckUI")
                                    }
                        
                                    Slide {
                                        Title("Slide 1")
                                        Words("Some useful content")
                                    }
                                }
                            }
                        }
                        """
                        }
                    }
                    
                    Column {
                        Bullets(style: .bullet) {
                            Words("Create a `Deck` with multiple `Slide` ")
                            Words("Create `Presenter` and give a deck")
                            Words("`Presenter` is a SwiftUI View to present a `Deck`")
                        }
                    }
                }
            }
        }

    public func nextSlide(animated: Bool = false) {
        var newIndex = self.slideIndex
        let slides = self.deck.slides()
        if newIndex >= (slides.count - 1) {
            if self.loop {
                newIndex = 0
            }
        } else {
            newIndex += 1
        }

        let nextSlide = slides[newIndex]

        // NOTE: The transition for removal used by SwiftUI
        // is the one that was set when rendering the slide.
        // This means that when changing navigation direction,
        // the animation would be wrong for the first transition
        // after changing direction.
        // By first updating the transition (causing a re-render
        // that doesn't change anything but the transition)
        // And then - in the next render loop - changing the
        // slide index, then we get the appropriate transition
        // even when changing directions.
        // This could be optimized to only perform the sleep
        // upon changing directions - by remembering the previous
        // transition direction and testing to see if it's
        // necessary to change the transition and re-render.
        self.activeTransition = (nextSlide.transition ?? self.slideTransition).next

        if animated {
            Task { @MainActor [newIndex] in
                try await Task.sleep(nanoseconds: 0)
                withAnimation {
                    self.slideIndex = newIndex
                }
            }
        } else {
            self.slideIndex = newIndex
        }
    }
    
    public func previousSlide(animated: Bool = false) {
        let slides = self.deck.slides()
        var newIndex = self.slideIndex
        let currSlide = slides[self.slideIndex]

        if newIndex <= 0 {
            if self.loop {
                newIndex = slides.count - 1
            }
        } else {
            newIndex -= 1
        }

        // NOTE: The transition for removal used by SwiftUI
        // is the one that was set when rendering the slide.
        // This means that when changing navigation direction,
        // the animation would be wrong for the first transition
        // after changing direction.
        // By first updating the transition (causing a re-render
        // that doesn't change anything but the transition)
        // And then - in the next render loop - changing the
        // slide index, then we get the appropriate transition
        // even when changing directions.
        // This could be optimized to only perform the sleep
        // upon changing directions - by remembering the previous
        // transition direction and testing to see if it's
        // necessary to change the transition and re-render.
        self.activeTransition = (currSlide.transition ?? self.slideTransition).previous

        if animated {
            Task { @MainActor [newIndex] in
                try await Task.sleep(nanoseconds: 0)
                withAnimation {
                    self.slideIndex = newIndex
                }
            }
        } else {
            self.slideIndex = newIndex
        }
    }
}
