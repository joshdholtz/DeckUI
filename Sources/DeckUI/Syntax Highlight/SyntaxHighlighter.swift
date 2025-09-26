//
//  SyntaxHighlighter.swift
//  DeckUI
//
//  Created by Claude on 2025-09-26.
//

import Foundation

struct SyntaxHighlighter {
    private let language: ProgrammingLanguage

    init(language: ProgrammingLanguage) {
        self.language = language
    }

    func highlight(_ text: String) -> [[CodeComponent]] {
        let lines = text.components(separatedBy: .newlines)
        var result: [[CodeComponent]] = []

        for line in lines {
            result.append(highlightLine(line))
        }

        return result
    }

    private func highlightLine(_ line: String) -> [CodeComponent] {
        switch language {
        case .swift:
            return highlightSwiftLine(line)
        default:
            // For non-Swift languages, just return plain text for now
            return [.plainText(line)]
        }
    }

    private func highlightSwiftLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        // Quick check for comments
        if trimmed.hasPrefix("//") {
            components.append(.token(trimmed, .comment))
            return components
        }

        // Tokenize the line
        let tokens = tokenize(trimmed)

        for token in tokens {
            components.append(categorizeToken(token))
        }

        return components
    }

    private func tokenize(_ text: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var inString = false
        var escapeNext = false

        for char in text {
            if escapeNext {
                currentToken.append(char)
                escapeNext = false
                continue
            }

            if char == "\\" && inString {
                escapeNext = true
                currentToken.append(char)
                continue
            }

            if char == "\"" {
                if inString {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inString = false
                } else {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = "\""
                    inString = true
                }
            } else if inString {
                currentToken.append(char)
            } else if char.isWhitespace {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if "(){}[]<>.,;:=+-*/!&|?".contains(char) {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else {
                currentToken.append(char)
            }
        }

        if !currentToken.isEmpty {
            tokens.append(currentToken)
        }

        return tokens
    }

    private func categorizeToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Strings
        if token.hasPrefix("\"") && token.hasSuffix("\"") {
            return .token(token, .string)
        }

        // Comments (single line)
        if token.hasPrefix("//") {
            return .token(token, .comment)
        }

        // Numbers
        if let first = token.first, (first.isNumber || (token.hasPrefix("0x") || token.hasPrefix("0o") || token.hasPrefix("0b"))) {
            if token.allSatisfy({ $0.isNumber || $0 == "." || $0 == "_" || "xXoObB".contains($0) }) {
                return .token(token, .number)
            }
        }

        // Keywords
        let keywords: Set<String> = [
            "class", "struct", "enum", "protocol", "extension",
            "func", "var", "let", "static", "private", "public",
            "internal", "fileprivate", "open",
            "import", "typealias", "associatedtype",
            "init", "deinit", "subscript",
            "override", "required", "convenience", "final",
            "lazy", "weak", "unowned",
            "guard", "if", "else", "switch", "case", "default", "where",
            "while", "for", "in", "do", "try", "catch", "throw", "throws", "rethrows",
            "as", "is", "super", "self", "Self",
            "return", "break", "continue", "fallthrough", "defer", "repeat",
            "true", "false", "nil",
            "async", "await", "actor", "some", "any"
        ]

        if keywords.contains(token) {
            return .token(token, .keyword)
        }

        // Types (capitalized identifiers and built-in types)
        let builtInTypes: Set<String> = [
            "Int", "Int8", "Int16", "Int32", "Int64",
            "UInt", "UInt8", "UInt16", "UInt32", "UInt64",
            "Float", "Double", "Bool", "String", "Character",
            "Array", "Dictionary", "Set", "Optional",
            "Any", "AnyObject", "Void", "Never", "Result", "Error",
            "View", "Text", "Button", "Image", "VStack", "HStack", "ZStack",
            "State", "Binding", "Published", "ObservedObject"
        ]

        if builtInTypes.contains(token) {
            return .token(token, .type)
        }

        if let first = token.first, first.isUppercase && first.isLetter {
            return .token(token, .type)
        }

        // Attributes
        if token.hasPrefix("@") {
            return .token(token, .preprocessing)
        }

        // Properties (starting with .)
        if token.hasPrefix(".") && token.count > 1 {
            return .token(token, .property)
        }

        // Default to plain text
        return .plainText(token)
    }
}