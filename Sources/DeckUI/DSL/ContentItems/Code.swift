//
//  Code.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Code: ContentItem {
    public let id = UUID()
    let text: String
    
    public init(_ text: String) {
        self.text = text
    }
    
    var lines: [String] {
        return text.components(separatedBy: "\n")
    }
    
    // TODO: Use theme
    public func buildView(theme: Theme) -> AnyView {
        AnyView(
            CodeView(lines: self.lines, theme: theme)
        )
    }
}

struct CodeView: View {
    let lines: [String]
    let theme: Theme
    let nonEmptyLineIndexes: [Int]
    
    @State var focusedLineIndex: Int?
    
    var focusedLine: Int? {
        guard let index = self.focusedLineIndex else {
            return nil
        }
        return self.nonEmptyLineIndexes[index]
    }
    
    init(lines: [String], theme: Theme) {
        self.lines = lines
        self.theme = theme
        
        self.nonEmptyLineIndexes = self.lines.enumerated().compactMap { (index, line) -> Int? in
            if line.filter({ !$0.isWhitespace }).isEmpty {
                return nil
            } else {
                return index
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScrollView {
                ForEach(Array(self.lines.enumerated()), id:\.offset) { index, line in
                    Text(line)
                        .font(
                            isFocused(index) ? self.theme.codeHighlighted.1.font : self.theme.code.font
                        )
                        .foregroundColor(
                            isFocused(index) ? self.theme.codeHighlighted.1.color : self.theme.code.color
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 1)
                        .background(isFocused(index) ? self.theme.codeHighlighted.0 : nil)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .keyUp), perform: { _ in
            self.previousLine()
        }).onReceive(NotificationCenter.default.publisher(for: .keyDown), perform: { _ in
            self.nextLine()
        })
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
