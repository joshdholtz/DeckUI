//
//  ThemeKey.swift
//  
//
//  Created by Danny North on 5/2/23.
//

import Foundation
import SwiftUI

public protocol ThemeKey {
    associatedtype Value
    
    static var defaultValue: Value { get }
}

internal struct BackgroundColorKey: ThemeKey {
    typealias Value = Color
    static let defaultValue: Color = .black
}

internal struct TitleKey: ThemeKey {
    typealias Value = Foreground
    static let defaultValue: Foreground = .init(color: .white, font: .system(.headline))
}

internal struct SubtitleKey: ThemeKey {
    typealias Value = Foreground
    static let defaultValue: Foreground = .init(color: .white, font: .system(.subheadline))
}

internal struct BodyKey: ThemeKey {
    typealias Value = Foreground
    static let defaultValue: Foreground = .init(color: .white, font: .system(.body))
}

internal struct CodeKey: ThemeKey {
    typealias Value = CodeTheme
    static let defaultValue: CodeTheme = .init(font: .system(.body, design: .monospaced),
                                               plainTextColor: .white,
                                               backgroundColor: .black,
                                               tokenColors: [:])
}

internal struct HighlightedCodeKey: ThemeKey {
    typealias Value = CodeTheme
    static let defaultValue: CodeTheme = .init(font: .system(.body, design: .monospaced),
                                               plainTextColor: .white,
                                               backgroundColor: .black,
                                               tokenColors: [:])
}
