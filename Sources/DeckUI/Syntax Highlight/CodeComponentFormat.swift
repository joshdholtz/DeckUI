//
//  CodeComponentFormat.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-11.
//

import Splash

struct CodeComponentFormat: OutputFormat {    
    func makeBuilder() -> Builder {
        return Builder()
    }
}

extension CodeComponentFormat {
    struct Builder: OutputBuilder {
        private var components: [[CodeComponent]]
        
        init() {
            self.components = [[CodeComponent]]()
            self.components.append([])
        }

        mutating func addToken(_ token: String, ofType type: TokenType) {
            components[components.count - 1].append(.token(token, type))
        }
        
        mutating func addPlainText(_ text: String) {
            components[components.count - 1].append(.plainText(text))
        }
        
        mutating func addWhitespace(_ whitespace: String) {
            let splitByNewLine = whitespace.split(separator: "\n", omittingEmptySubsequences: false)
            let lines = splitByNewLine.count
            for (i, blanks) in splitByNewLine.enumerated() {
                components[components.count - 1].append(.whitespace(String(blanks)))
                if i < (lines - 1) {
                    components.append([])
                }
            }
        }
        
        func build() -> [[CodeComponent]] {
            components
        }
    }
}
