//
//  Presenter.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Presenter: View {
    public enum SlideDirection {
        case horizontal, vertical
        
        var next: AnyTransition {
            switch self {
            case .horizontal:
                return .slideFromTrailing
            case .vertical:
                return .slideFromBottom
            }
        }
        
        var previous: AnyTransition {
            switch self {
            case .horizontal:
                return .slideFromLeading
            case .vertical:
                return .slideFromTop
            }
        }
    }
    
    let deck: Deck
    let slideDirection: SlideDirection
    let loop: Bool
    
    @State var index = 0
    @State var isFullScreen = false
    @State var activeTransition: AnyTransition = .slideFromTrailing
    
    public init(deck: Deck, slideDirection: SlideDirection = .horizontal, loop: Bool = false) {
        self.deck = deck
        self.slideDirection = slideDirection
        self.loop = loop
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
                        .zIndex(Double(self.index))
                }
            }.transition(self.activeTransition)
            
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
        .navigationTitle(self.deck.title)
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
        self.activeTransition = self.slideDirection.next
        
        let slides = self.deck.slides()
        if self.index >= (slides.count - 1) {
            if self.loop {
                self.index = 0
            }
        } else {
            self.index += 1
        }
    }
    
    private func previousSlide() {
        self.activeTransition = self.slideDirection.previous
        
        let slides = self.deck.slides()
        if self.index <= 0 {
            if self.loop {
                self.index = slides.count - 1
            }
        } else {
            self.index -= 1
        }
    }
}
extension AnyTransition {
    static var slideFromBottom: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .top))
        
    }
    
    static var slideFromTop: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .top),
            removal: .move(edge: .bottom))
        
    }
    
    static var slideFromTrailing: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
        
    }
    
    static var slideFromLeading: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .leading),
            removal: .move(edge: .trailing))
        
    }
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
