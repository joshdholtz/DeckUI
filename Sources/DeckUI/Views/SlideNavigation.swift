//
//  SlideNavigation.swift
//  
//
//  Created by Zachary Brass on 3/18/23.
//

import SwiftUI

public struct SlideNavigationToolbarButtons: View {
    public var body: some View {
        Group {
            Button {
                print("⬅️ Previous slide triggered via Left Arrow")
                withAnimation {
                    PresentationState.shared.previousSlide()
                }
            } label: {
                Label("Previous", systemImage: "arrow.left")
            }.keyboardShortcut(.leftArrow, modifiers: [])

            Button {
                print("➡️ Next slide triggered via Right Arrow")
                withAnimation {
                    PresentationState.shared.nextSlide()
                }
            } label: {
                Label("Next", systemImage: "arrow.right")
            }.keyboardShortcut(.rightArrow, modifiers: [])

            Button {
                NotificationCenter.default.post(name: .keyDown, object: nil)
            } label: {
                Label("Down", systemImage: "arrow.down")
            }.keyboardShortcut(.downArrow, modifiers: [])

            Button {
                NotificationCenter.default.post(name: .keyUp, object: nil)
            } label: {
                Label("Up", systemImage: "arrow.up")
            }.keyboardShortcut(.upArrow, modifiers: [])

            // Hidden buttons for clicker/presenter support
            // Space bar for next slide (most common clicker button)
            Button {
                print("⏸️ Next slide triggered via Space Bar")
                withAnimation {
                    PresentationState.shared.nextSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.space, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Enter/Return key for next slide
            Button {
                print("⏎ Next slide triggered via Enter/Return")
                withAnimation {
                    PresentationState.shared.nextSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.return, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Escape key for previous slide (some clickers use this)
            Button {
                print("⎋ Previous slide triggered via Escape")
                withAnimation {
                    PresentationState.shared.previousSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.escape, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Tab key for next slide (some clickers)
            Button {
                print("⇥ Next slide triggered via Tab")
                withAnimation {
                    PresentationState.shared.nextSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.tab, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Shift+Tab for previous slide
            Button {
                print("⇤ Previous slide triggered via Shift+Tab")
                withAnimation {
                    PresentationState.shared.previousSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.tab, modifiers: [.shift])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Page Down for next slide (common clicker button)
            Button {
                print("⬇️ Next slide triggered via Page Down")
                withAnimation {
                    PresentationState.shared.nextSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.pageDown, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)

            // Page Up for previous slide
            Button {
                print("⬆️ Previous slide triggered via Page Up")
                withAnimation {
                    PresentationState.shared.previousSlide()
                }
            } label: {
                EmptyView()
            }
            .keyboardShortcut(.pageUp, modifiers: [])
            .opacity(0)
            .frame(width: 0, height: 0)
        }
    }
    public init() {
        
    }
}

extension View {
    public func slideNavigationGestures() -> some View {
        return gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
            .onEnded { value in
                let tolerance: ClosedRange<CGFloat> = -100...100
                switch(value.translation.width, value.translation.height) {
                case (tolerance, ...0):  NotificationCenter.default.post(name: .keyUp, object: nil)
                case (tolerance, 0...):  NotificationCenter.default.post(name: .keyDown, object: nil)
                case (...0, tolerance):  PresentationState.shared.nextSlide()
                case (0..., tolerance):  PresentationState.shared.previousSlide()
                default:  break
                }
            }
        )
    }
}
