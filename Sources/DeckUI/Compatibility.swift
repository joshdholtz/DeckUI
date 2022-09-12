//
//  Compatibility.swift
//  DeckUI
//
//  Created by Alexandr Goncharov on 12.09.2022.
//

#if canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
public typealias PlatformView = NSView
public typealias PlatformViewRepresentable = NSViewRepresentable
#elseif canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
public typealias PlatformView = UIView
public typealias PlatformViewRepresentable = UIViewRepresentable
#endif

import SwiftUI

extension Image {
    init(platformImage: PlatformImage) {
        #if canImport(UIKit)
        self = Image(uiImage: platformImage)
        #elseif canImport(AppKit)
        self = Image(nsImage: platformImage)
        #endif
    }
}

// Taken from: https://gist.github.com/insidegui/97d821ca933c8627e7f614bc1d6b4983

/// Implementers get automatic `UIViewRepresentable` conformance on iOS
/// and `NSViewRepresentable` conformance on macOS.
public protocol PlatformAgnosticViewRepresentable: PlatformViewRepresentable {
    associatedtype PlatformViewType

    func makePlatformView(context: Context) -> PlatformViewType
    func updatePlatformView(_ platformView: PlatformViewType, context: Context)
}

#if canImport(AppKit)
public extension PlatformAgnosticViewRepresentable where NSViewType == PlatformViewType {
    func makeNSView(context: Context) -> NSViewType {
        makePlatformView(context: context)
    }

    func updateNSView(_ nsView: NSViewType, context: Context) {
        updatePlatformView(nsView, context: context)
    }
}
#elseif canImport(UIKit)
public extension PlatformAgnosticViewRepresentable where UIViewType == PlatformViewType {
    func makeUIView(context: Context) -> UIViewType {
        makePlatformView(context: context)
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        updatePlatformView(uiView, context: context)
    }
}
#endif
