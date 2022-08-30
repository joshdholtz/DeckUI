//
//  Presenter.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Presenter: View {
    let deck: Deck
    
    @State var index = 0
    @State var isFullScreen = false
    
    public init(deck: Deck) {
        self.deck = deck
    }
    
    var slide: Slide? {
        let slides = self.deck.slides()
        if slides.count > index {
            return slides[index]
        } else {
            return nil
        }
    }
    
    public var body: some View {
        ZStack {
            if self.isFullScreen {
                VStack {
                    self.toolbarButtons
                }.opacity(0)
            }
            
            ForEach(Array(self.deck.slides().enumerated()), id: \.offset) { index, slide in
                
                if index == self.index {
                    slide.view
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .transition(.move(edge: .bottom))
//                        .transition(.scale)
                        .transition(.backslide)
                        .zIndex(Double(self.index))
                }
            }
            
//            if let slide = self.slide {
//                slide.view
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(.move(edge: .bottom))
//                    .zIndex(Double(self.index))
//            } else {
//                Text("No slide...")
//                    .italic()
//            }
        }
        .frame(width: 1280, height: 700)
        .if(!self.isFullScreen) {
            $0.toolbar {
                ToolbarItemGroup {
                    self.toolbarButtons
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willEnterFullScreenNotification)) { _ in
            self.isFullScreen = true
        }
        .onReceive(NotificationCenter.default.publisher(for: NSWindow.willExitFullScreenNotification)) { _ in
            self.isFullScreen = false
        }
    }
    
    var toolbarButtons: some View {
        Group {
            Button {
                withAnimation {
                    self.previousSlide()
                }
            } label: {
                Label("Previous", systemImage: "arrow.left")
            }.keyboardShortcut(.leftArrow, modifiers: [])
            
            Button {
                withAnimation {
                    self.nextSlide()
                }
            } label: {
                Label("Next", systemImage: "arrow.right")
            }.keyboardShortcut(.rightArrow, modifiers: [])
        }
    }
    
    private func nextSlide() {
        let slides = self.deck.slides()
        if self.index >= (slides.count - 1) {
            self.index = 0
        } else {
            self.index += 1
        }
    }
    
    private func previousSlide() {
        let slides = self.deck.slides()
        if self.index <= 0 {
            self.index = slides.count - 1
        } else {
            self.index -= 1
        }
    }
}
extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}
