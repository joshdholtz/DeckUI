//
//  DemoApp.swift
//  Shared
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI
import DeckUI
@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        #if canImport(AppKit)
        PresenterNotes()
        #endif
    }
}
