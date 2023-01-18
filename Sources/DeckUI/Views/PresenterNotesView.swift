//
//  PresenterView.swift
//  Demo
//
//  Created by Zachary Brass on 1/17/23.
//

import Splash
import SwiftUI
public struct PresenterNotesView: View {
    @ObservedObject private var presentationState = PresentationState.shared
    
    public var body: some View {
        Text(presentationState.deck.slides()[presentationState.slideIndex].comment ?? "No notes")
        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
    }
    public init() {
    }
        
    
}
#if canImport(AppKit)
@available(macOS 13.0, *)
public struct PresenterNotes: Scene {
    public var body: some Scene {
        Window("Presenter Notes", id: "notes") {
            PresenterNotesView()
                .toolbar {
                    SlideNavigationToolbarButtons()
                }
        }.keyboardShortcut("1")

    }
    public init() {
    }
}
#endif
