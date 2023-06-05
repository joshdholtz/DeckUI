//
//  Code.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import Splash
import SwiftUI

public struct Code: ContentItem {
    public let id = UUID()
    let text: String
    let enableHighlight: Bool
    let language: ProgrammingLanguage
    
    public init(_ language: ProgrammingLanguage = .none, enableHighlight: Bool = true, text: () -> String) {
        self.text = text()
        self.enableHighlight = enableHighlight
        self.language = language
    }
    
    public func buildView(theme: Theme) -> AnyView {
        let format = CodeComponentFormat()
        let highlighter = SyntaxHighlighter(format: format, grammar: self.language.grammar)
        let components = highlighter.highlight(self.text)

        return AnyView(
            CodeView(components: components, enableHighlight: self.enableHighlight, theme: theme)
        )
    }
}

struct CodeView: View {
    let components: [[CodeComponent]]
    let enableHighlight: Bool
    let theme: Theme
    let nonEmptyLineIndexes: [Int]
    @Environment(\.isRenderingPDF) var isRenderingPDF
    
    @State var focusedLineIndex: Int?
    
    var focusedLine: Int? {
        guard let index = self.focusedLineIndex else {
            return nil
        }
        return self.nonEmptyLineIndexes[index]
    }
    
    init(components: [[CodeComponent]], enableHighlight: Bool, theme: Theme) {
        self.components = components
        self.enableHighlight = enableHighlight
        self.theme = theme
        
        self.nonEmptyLineIndexes = self.components.enumerated().compactMap { (index, line) -> Int? in
            if line.filter({ !$0.isWhitespace }).isEmpty {
                return nil
            } else {
                return index
            }
        }
    }

    private var content: some View {
        ForEach(Array(self.components.enumerated()), id:\.offset) { index, line in
            Text(attributedString(for: line, highlight: isFocused(index)))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 1)
                .background(isFocused(index) ? self.theme.codeHighlighted.backgroundColor : nil)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isRenderingPDF {
                VStack {
                    content
                }
            } else {
                ScrollView {
                    content
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .keyUp), perform: { _ in
            if self.enableHighlight {
                self.previousLine()
            }
        }).onReceive(NotificationCenter.default.publisher(for: .keyDown), perform: { _ in
            if self.enableHighlight {
                self.nextLine()
            }
        })
    }
    
    
    private func attributedString(for line: [CodeComponent], highlight: Bool) -> AttributedString {
        let codeTheme = highlight ? theme.codeHighlighted : theme.code
        var attrStr = AttributedString()
        for component in line {
            attrStr += codeTheme.text(for: component)
        }
        return attrStr
    }
    
    private func nextLine() {
        if let index = self.focusedLineIndex {
            if index >= (nonEmptyLineIndexes.count - 1) {
                // No op
            } else {
                let newIndex = index + 1
                self.focusedLineIndex = newIndex
            }
        } else {
            self.focusedLineIndex = 0
        }
    }
    
    private func previousLine() {
        guard let index = self.focusedLineIndex else {
            return
        }
        
        if index <= 0 {
            // No op
        } else {
            self.focusedLineIndex = index - 1
        }
    }
    
    private func isFocused(_ line: Int) -> Bool {
        if let focusedLine = self.focusedLine {
            return focusedLine == line
        } else {
            return false
        }
    }
}
