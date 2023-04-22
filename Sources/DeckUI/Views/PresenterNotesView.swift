//
//  PresenterView.swift
//  Demo
//
//  Created by Zachary Brass on 1/17/23.
//

import SwiftUI
public struct PresenterNotesView: View {
    @ObservedObject private var presentationState = PresentationState.shared
    
    public var body: some View {
        Group{
            Text(presentationState.deck.slides()[presentationState.slideIndex].comment ?? "No notes")

        }.frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(.background)
        #if canImport(UIKit)
        .slideNavigationGestures()
        #endif
        
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
