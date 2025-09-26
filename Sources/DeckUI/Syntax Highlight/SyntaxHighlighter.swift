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
        case .ruby:
            return highlightRubyLine(line)
        case .objc:
            return highlightObjectiveCLine(line)
        case .bash:
            return highlightBashLine(line)
        case .sql:
            return highlightSQLLine(line)
        case .html:
            return highlightHTMLLine(line)
        case .regex:
            return highlightRegexLine(line)
        default:
            // For unsupported languages, just return plain text
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

    // MARK: - Ruby Highlighting

    private func highlightRubyLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        // Quick check for comments
        if trimmed.hasPrefix("#") {
            components.append(.token(trimmed, .comment))
            return components
        }

        // Tokenize the line
        let tokens = tokenizeRuby(trimmed)

        for token in tokens {
            components.append(categorizeRubyToken(token))
        }

        return components
    }

    private func tokenizeRuby(_ text: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var inString = false
        var stringDelimiter: Character?
        var escapeNext = false
        var inSymbol = false

        for char in text {
            if escapeNext {
                currentToken.append(char)
                escapeNext = false
                continue
            }

            if char == "\\" && (inString || inSymbol) {
                escapeNext = true
                currentToken.append(char)
                continue
            }

            // Handle strings (both single and double quotes)
            if (char == "\"" || char == "'") && !inSymbol {
                if inString && char == stringDelimiter {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inString = false
                    stringDelimiter = nil
                } else if !inString {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = String(char)
                    inString = true
                    stringDelimiter = char
                } else {
                    currentToken.append(char)
                }
            } else if inString {
                currentToken.append(char)
            } else if char == ":" && !currentToken.isEmpty && currentToken != ":" {
                // Handle symbols that come after colons
                tokens.append(currentToken)
                currentToken = ":"
                inSymbol = true
            } else if inSymbol && (char.isLetter || char.isNumber || char == "_") {
                currentToken.append(char)
            } else if inSymbol {
                tokens.append(currentToken)
                currentToken = ""
                inSymbol = false
                // Process this character normally
                if char.isWhitespace {
                    tokens.append(String(char))
                } else if "(){}[]<>.,;=+-*/!&|?@$%".contains(char) {
                    tokens.append(String(char))
                } else {
                    currentToken = String(char)
                }
            } else if char.isWhitespace {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if "(){}[]<>.,;=+-*/!&|?@$%".contains(char) {
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

    private func categorizeRubyToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Strings
        if (token.hasPrefix("\"") && token.hasSuffix("\"")) ||
           (token.hasPrefix("'") && token.hasSuffix("'")) {
            return .token(token, .string)
        }

        // Comments
        if token.hasPrefix("#") {
            return .token(token, .comment)
        }

        // Symbols
        if token.hasPrefix(":") && token.count > 1 {
            return .token(token, .property)
        }

        // Instance variables
        if token.hasPrefix("@") {
            return .token(token, .property)
        }

        // Class variables
        if token.hasPrefix("@@") {
            return .token(token, .property)
        }

        // Global variables
        if token.hasPrefix("$") {
            return .token(token, .property)
        }

        // Numbers
        if let first = token.first, first.isNumber {
            if token.allSatisfy({ $0.isNumber || $0 == "." || $0 == "_" || $0 == "e" || $0 == "E" || $0 == "-" || $0 == "+" }) {
                return .token(token, .number)
            }
        }

        // Ruby Keywords
        let rubyKeywords: Set<String> = [
            // Control flow
            "if", "elsif", "else", "unless", "case", "when", "while", "until", "for", "break", "next",
            "redo", "retry", "return", "yield",
            // Definitions
            "def", "class", "module", "begin", "end", "rescue", "ensure", "raise",
            // Boolean and nil
            "true", "false", "nil",
            // Other keywords
            "do", "and", "or", "not", "in", "then", "self", "super",
            "alias", "defined?", "undef",
            // Access modifiers
            "public", "private", "protected",
            // Require/include
            "require", "require_relative", "include", "extend", "prepend",
            // Attributes
            "attr_reader", "attr_writer", "attr_accessor"
        ]

        if rubyKeywords.contains(token) {
            return .token(token, .keyword)
        }

        // Ruby built-in classes/modules (types)
        let rubyTypes: Set<String> = [
            "Array", "Hash", "String", "Integer", "Float", "Numeric", "Symbol",
            "TrueClass", "FalseClass", "NilClass", "Class", "Module", "Object",
            "Kernel", "BasicObject", "Enumerable", "Comparable",
            "File", "Dir", "IO", "Time", "Date", "DateTime",
            "Regexp", "Range", "Proc", "Lambda", "Method",
            "Exception", "StandardError", "RuntimeError", "ArgumentError",
            "TypeError", "NameError", "NoMethodError", "SyntaxError"
        ]

        if rubyTypes.contains(token) {
            return .token(token, .type)
        }

        // Constants (capitalized identifiers)
        if let first = token.first, first.isUppercase && first.isLetter {
            return .token(token, .type)
        }

        // Method calls with . or ::
        if token == "." || token == "::" {
            return .token(token, .dotAccess)
        }

        // Default to plain text
        return .plainText(token)
    }

    // MARK: - Objective-C Highlighting

    private func highlightObjectiveCLine(_ line: String) -> [CodeComponent] {
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
        let tokens = tokenize(trimmed) // Reuse Swift tokenizer, it's similar enough

        for token in tokens {
            components.append(categorizeObjectiveCToken(token))
        }

        return components
    }

    private func categorizeObjectiveCToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Strings
        if token.hasPrefix("\"") && token.hasSuffix("\"") {
            return .token(token, .string)
        }

        // Objective-C string literals
        if token.hasPrefix("@\"") {
            return .token(token, .string)
        }

        // Comments
        if token.hasPrefix("//") || token.hasPrefix("/*") || token.hasPrefix("*") {
            return .token(token, .comment)
        }

        // Numbers
        if let first = token.first, first.isNumber {
            if token.allSatisfy({ $0.isNumber || $0 == "." || $0 == "f" || $0 == "L" || $0 == "u" || $0 == "U" }) {
                return .token(token, .number)
            }
        }

        // Preprocessor directives
        if token.hasPrefix("#") {
            return .token(token, .preprocessing)
        }

        // Objective-C literals and attributes
        if token.hasPrefix("@") {
            let objcKeywords = ["@interface", "@implementation", "@protocol", "@class", "@property",
                               "@synthesize", "@dynamic", "@selector", "@encode", "@synchronized",
                               "@try", "@catch", "@finally", "@throw", "@autoreleasepool",
                               "@available", "@optional", "@required", "@public", "@private",
                               "@protected", "@package", "@end"]
            if objcKeywords.contains(token) {
                return .token(token, .keyword)
            }
            return .token(token, .preprocessing)
        }

        // Objective-C Keywords
        let objcKeywords: Set<String> = [
            // C keywords
            "auto", "break", "case", "char", "const", "continue", "default", "do",
            "double", "else", "enum", "extern", "float", "for", "goto", "if",
            "int", "long", "register", "return", "short", "signed", "sizeof", "static",
            "struct", "switch", "typedef", "union", "unsigned", "void", "volatile", "while",
            // Objective-C specific
            "id", "Class", "SEL", "IMP", "BOOL", "YES", "NO", "nil", "NULL", "Nil",
            "self", "super", "in", "out", "inout", "bycopy", "byref", "oneway",
            "instancetype", "nullable", "nonnull", "_Nullable", "_Nonnull",
            "weak", "strong", "copy", "assign", "retain", "nonatomic", "atomic",
            "readonly", "readwrite", "getter", "setter",
            // Common
            "IBAction", "IBOutlet", "IBInspectable", "IBDesignable"
        ]

        if objcKeywords.contains(token) {
            return .token(token, .keyword)
        }

        // Objective-C Types
        let objcTypes: Set<String> = [
            "NSString", "NSNumber", "NSArray", "NSDictionary", "NSSet",
            "NSMutableString", "NSMutableArray", "NSMutableDictionary", "NSMutableSet",
            "NSObject", "NSData", "NSDate", "NSURL", "NSError", "NSException",
            "UIView", "UIViewController", "UIButton", "UILabel", "UITextField",
            "UITableView", "UICollectionView", "UIImage", "UIImageView",
            "CGFloat", "CGPoint", "CGSize", "CGRect", "NSInteger", "NSUInteger",
            "dispatch_queue_t", "dispatch_once_t"
        ]

        if objcTypes.contains(token) {
            return .token(token, .type)
        }

        // Capitalized identifiers (likely classes)
        if let first = token.first, first.isUppercase && first.isLetter {
            return .token(token, .type)
        }

        // Method/property access
        if token.hasPrefix(".") && token.count > 1 {
            return .token(token, .property)
        }

        // Square brackets (method calls)
        if token == "[" || token == "]" {
            return .token(token, .call)
        }

        // Default to plain text
        return .plainText(token)
    }

    // MARK: - Bash Highlighting

    private func highlightBashLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        // Quick check for comments
        if trimmed.hasPrefix("#") && !trimmed.hasPrefix("#!") {
            components.append(.token(trimmed, .comment))
            return components
        }

        // Handle shebang
        if trimmed.hasPrefix("#!") {
            components.append(.token(trimmed, .preprocessing))
            return components
        }

        // Tokenize the line
        let tokens = tokenizeBash(trimmed)

        for token in tokens {
            components.append(categorizeBashToken(token))
        }

        return components
    }

    private func tokenizeBash(_ text: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var inSingleQuote = false
        var inDoubleQuote = false
        var inBacktick = false
        var escapeNext = false

        for char in text {
            if escapeNext {
                currentToken.append(char)
                escapeNext = false
                continue
            }

            if char == "\\" && !inSingleQuote {
                escapeNext = true
                currentToken.append(char)
                continue
            }

            // Handle quotes
            if char == "'" && !inDoubleQuote && !inBacktick {
                if inSingleQuote {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inSingleQuote = false
                } else {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = "'"
                    inSingleQuote = true
                }
            } else if char == "\"" && !inSingleQuote && !inBacktick {
                if inDoubleQuote {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inDoubleQuote = false
                } else {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = "\""
                    inDoubleQuote = true
                }
            } else if char == "`" && !inSingleQuote && !inDoubleQuote {
                if inBacktick {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inBacktick = false
                } else {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = "`"
                    inBacktick = true
                }
            } else if inSingleQuote || inDoubleQuote || inBacktick {
                currentToken.append(char)
            } else if char.isWhitespace {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if "(){}[]<>|&;$".contains(char) {
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

    private func categorizeBashToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Strings
        if (token.hasPrefix("\"") && token.hasSuffix("\"")) ||
           (token.hasPrefix("'") && token.hasSuffix("'")) ||
           (token.hasPrefix("`") && token.hasSuffix("`")) {
            return .token(token, .string)
        }

        // Comments
        if token.hasPrefix("#") && !token.hasPrefix("#!") {
            return .token(token, .comment)
        }

        // Shebang
        if token.hasPrefix("#!") {
            return .token(token, .preprocessing)
        }

        // Variables (starting with $)
        if token.hasPrefix("$") {
            return .token(token, .property)
        }

        // Numbers
        if let first = token.first, first.isNumber {
            if token.allSatisfy({ $0.isNumber || $0 == "." }) {
                return .token(token, .number)
            }
        }

        // Bash keywords and built-ins
        let bashKeywords: Set<String> = [
            // Control flow
            "if", "then", "else", "elif", "fi", "case", "esac", "for", "while",
            "until", "do", "done", "break", "continue", "function", "return",
            // Built-in commands
            "echo", "printf", "read", "cd", "pwd", "ls", "cp", "mv", "rm", "mkdir",
            "rmdir", "touch", "cat", "grep", "sed", "awk", "find", "sort", "uniq",
            "head", "tail", "cut", "tr", "wc", "diff", "chmod", "chown", "ps",
            "kill", "jobs", "bg", "fg", "export", "unset", "alias", "source",
            "exit", "exec", "eval", "set", "unset", "shift", "test", "true", "false",
            // Conditionals
            "[[", "]]", "[", "]",
            // Other
            "sudo", "apt", "apt-get", "yum", "brew", "npm", "pip", "git", "docker",
            "curl", "wget", "ssh", "scp", "tar", "gzip", "gunzip", "zip", "unzip"
        ]

        if bashKeywords.contains(token) {
            return .token(token, .keyword)
        }

        // Operators and special characters
        if ["&&", "||", ">>", "<<", "|", "&", ";", ">", "<", "=", "!=", "=="].contains(token) {
            return .token(token, .keyword)
        }

        // Flags (starting with -)
        if token.hasPrefix("-") && token.count > 1 {
            return .token(token, .property)
        }

        // Default to plain text
        return .plainText(token)
    }

    // MARK: - SQL Highlighting

    private func highlightSQLLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        // Quick check for comments
        if trimmed.hasPrefix("--") {
            components.append(.token(trimmed, .comment))
            return components
        }

        // Tokenize the line
        let tokens = tokenizeSQL(trimmed)

        for token in tokens {
            components.append(categorizeSQLToken(token))
        }

        return components
    }

    private func tokenizeSQL(_ text: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var inString = false
        var stringDelimiter: Character?
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

            // Handle strings (both single and double quotes)
            if (char == "\"" || char == "'") {
                if inString && char == stringDelimiter {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inString = false
                    stringDelimiter = nil
                } else if !inString {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = String(char)
                    inString = true
                    stringDelimiter = char
                } else {
                    currentToken.append(char)
                }
            } else if inString {
                currentToken.append(char)
            } else if char.isWhitespace {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if "(),;=<>!*".contains(char) {
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

    private func categorizeSQLToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Strings
        if (token.hasPrefix("\"") && token.hasSuffix("\"")) ||
           (token.hasPrefix("'") && token.hasSuffix("'")) {
            return .token(token, .string)
        }

        // Comments
        if token.hasPrefix("--") {
            return .token(token, .comment)
        }

        // Numbers
        if let first = token.first, first.isNumber {
            if token.allSatisfy({ $0.isNumber || $0 == "." }) {
                return .token(token, .number)
            }
        }

        // SQL Keywords (case-insensitive)
        let sqlKeywords: Set<String> = [
            // DDL
            "CREATE", "ALTER", "DROP", "TRUNCATE", "RENAME",
            "TABLE", "DATABASE", "SCHEMA", "INDEX", "VIEW",
            // DML
            "SELECT", "INSERT", "UPDATE", "DELETE", "MERGE",
            "FROM", "WHERE", "JOIN", "INNER", "LEFT", "RIGHT", "OUTER", "CROSS",
            "ON", "AS", "INTO", "VALUES", "SET",
            // Clauses
            "GROUP", "BY", "ORDER", "HAVING", "LIMIT", "OFFSET",
            "DISTINCT", "ALL", "TOP", "ASC", "DESC",
            // Conditions
            "AND", "OR", "NOT", "IN", "EXISTS", "BETWEEN", "LIKE", "IS", "NULL",
            "ANY", "SOME", "ALL",
            // Functions
            "COUNT", "SUM", "AVG", "MIN", "MAX", "ROUND", "CONCAT",
            "SUBSTRING", "LENGTH", "UPPER", "LOWER", "TRIM",
            // Transaction
            "BEGIN", "COMMIT", "ROLLBACK", "TRANSACTION", "SAVEPOINT",
            // Constraints
            "PRIMARY", "KEY", "FOREIGN", "UNIQUE", "CHECK", "DEFAULT",
            "NOT", "NULL", "REFERENCES", "CONSTRAINT",
            // Data Types
            "INT", "INTEGER", "VARCHAR", "CHAR", "TEXT", "DATE", "DATETIME",
            "TIMESTAMP", "BOOLEAN", "DECIMAL", "FLOAT", "DOUBLE", "BLOB",
            // Other
            "CASE", "WHEN", "THEN", "ELSE", "END", "UNION", "INTERSECT", "EXCEPT"
        ]

        if sqlKeywords.contains(token.uppercased()) {
            return .token(token, .keyword)
        }

        // Common SQL Functions as types
        let sqlFunctions: Set<String> = [
            "COALESCE", "CAST", "CONVERT", "NOW", "CURRENT_DATE", "CURRENT_TIME",
            "CURRENT_TIMESTAMP", "EXTRACT", "DATE_ADD", "DATE_SUB", "DATEDIFF"
        ]

        if sqlFunctions.contains(token.uppercased()) {
            return .token(token, .call)
        }

        // Default to plain text
        return .plainText(token)
    }

    // MARK: - HTML Highlighting

    private func highlightHTMLLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        // Quick check for comments
        if trimmed.hasPrefix("<!--") {
            components.append(.token(trimmed, .comment))
            return components
        }

        // Tokenize the line
        let tokens = tokenizeHTML(trimmed)

        for token in tokens {
            components.append(categorizeHTMLToken(token))
        }

        return components
    }

    private func tokenizeHTML(_ text: String) -> [String] {
        var tokens: [String] = []
        var currentToken = ""
        var inTag = false
        var inString = false
        var stringDelimiter: Character?

        for char in text {
            if char == "<" && !inString {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                currentToken.append(char)
                inTag = true
            } else if char == ">" && inTag && !inString {
                currentToken.append(char)
                tokens.append(currentToken)
                currentToken = ""
                inTag = false
            } else if (char == "\"" || char == "'") && inTag {
                if inString && char == stringDelimiter {
                    currentToken.append(char)
                    tokens.append(currentToken)
                    currentToken = ""
                    inString = false
                    stringDelimiter = nil
                } else if !inString {
                    if !currentToken.isEmpty {
                        tokens.append(currentToken)
                    }
                    currentToken = String(char)
                    inString = true
                    stringDelimiter = char
                } else {
                    currentToken.append(char)
                }
            } else if inString {
                currentToken.append(char)
            } else if char.isWhitespace && !inTag {
                if !currentToken.isEmpty {
                    tokens.append(currentToken)
                    currentToken = ""
                }
                tokens.append(String(char))
            } else if char.isWhitespace && inTag && !inString {
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

    private func categorizeHTMLToken(_ token: String) -> CodeComponent {
        // Whitespace
        if token.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespace(token)
        }

        // Comments
        if token.hasPrefix("<!--") && token.hasSuffix("-->") {
            return .token(token, .comment)
        }

        // Strings (attribute values)
        if (token.hasPrefix("\"") && token.hasSuffix("\"")) ||
           (token.hasPrefix("'") && token.hasSuffix("'")) {
            return .token(token, .string)
        }

        // DOCTYPE
        if token.hasPrefix("<!DOCTYPE") || token.hasPrefix("<!doctype") {
            return .token(token, .preprocessing)
        }

        // Tags
        if token.hasPrefix("</") || token.hasPrefix("<") {
            // Extract tag name
            let tagContent = token.replacingOccurrences(of: "</", with: "")
                                 .replacingOccurrences(of: "<", with: "")
                                 .replacingOccurrences(of: ">", with: "")
                                 .replacingOccurrences(of: "/", with: "")

            let htmlTags: Set<String> = [
                "html", "head", "body", "title", "meta", "link", "script", "style",
                "div", "span", "p", "a", "img", "ul", "ol", "li", "table", "tr", "td", "th",
                "form", "input", "button", "select", "option", "textarea", "label",
                "h1", "h2", "h3", "h4", "h5", "h6", "header", "footer", "nav", "main",
                "section", "article", "aside", "figure", "figcaption", "video", "audio",
                "canvas", "svg", "iframe", "embed", "object", "param", "source",
                "strong", "em", "b", "i", "u", "sub", "sup", "br", "hr", "pre", "code"
            ]

            if htmlTags.contains(tagContent.lowercased()) {
                return .token(token, .keyword)
            }
            return .token(token, .keyword)
        }

        // HTML attributes
        let htmlAttributes: Set<String> = [
            "id", "class", "style", "src", "href", "alt", "title", "width", "height",
            "name", "value", "type", "placeholder", "disabled", "readonly", "required",
            "checked", "selected", "multiple", "rows", "cols", "size", "maxlength",
            "min", "max", "step", "pattern", "accept", "autocomplete", "autofocus",
            "data-", "aria-", "role", "tabindex", "target", "rel", "method", "action",
            "for", "content", "charset", "lang", "dir", "onclick", "onchange", "onload"
        ]

        for attr in htmlAttributes {
            if token.lowercased().hasPrefix(attr) {
                return .token(token, .property)
            }
        }

        // Equals sign
        if token == "=" {
            return .token(token, .keyword)
        }

        // Default to plain text
        return .plainText(token)
    }

    // MARK: - Regex Highlighting

    private func highlightRegexLine(_ line: String) -> [CodeComponent] {
        var components: [CodeComponent] = []

        // Handle leading whitespace
        let leadingWhitespace = line.prefix(while: { $0.isWhitespace })
        if !leadingWhitespace.isEmpty {
            components.append(.whitespace(String(leadingWhitespace)))
        }

        let trimmed = String(line.dropFirst(leadingWhitespace.count))

        // Process regex character by character
        var i = trimmed.startIndex
        while i < trimmed.endIndex {
            let char = trimmed[i]

            // Escape sequences
            if char == "\\" && trimmed.index(after: i) < trimmed.endIndex {
                let nextIndex = trimmed.index(after: i)
                let nextChar = trimmed[nextIndex]

                // Special regex escape sequences
                if "dDwWsSbBnrt".contains(nextChar) {
                    components.append(.token(String(trimmed[i...nextIndex]), .keyword))
                    i = trimmed.index(after: nextIndex)
                } else {
                    // Regular escape
                    components.append(.token(String(trimmed[i...nextIndex]), .string))
                    i = trimmed.index(after: nextIndex)
                }
                continue
            }

            // Character classes
            if char == "[" {
                var j = trimmed.index(after: i)
                var foundClose = false
                while j < trimmed.endIndex {
                    if trimmed[j] == "]" {
                        foundClose = true
                        components.append(.token(String(trimmed[i...j]), .type))
                        i = trimmed.index(after: j)
                        break
                    }
                    j = trimmed.index(after: j)
                }
                if !foundClose {
                    components.append(.plainText(String(char)))
                    i = trimmed.index(after: i)
                }
                continue
            }

            // Groups
            if char == "(" {
                // Check for special group syntax
                if trimmed.index(after: i) < trimmed.endIndex && trimmed[trimmed.index(after: i)] == "?" {
                    var j = trimmed.index(after: i)
                    j = trimmed.index(after: j)
                    if j < trimmed.endIndex {
                        let specialChar = trimmed[j]
                        if ":<>=!".contains(specialChar) {
                            // Find the closing parenthesis
                            var k = trimmed.index(after: j)
                            var depth = 1
                            while k < trimmed.endIndex && depth > 0 {
                                if trimmed[k] == "(" { depth += 1 }
                                else if trimmed[k] == ")" { depth -= 1 }
                                if depth == 0 { break }
                                k = trimmed.index(after: k)
                            }
                            if depth == 0 {
                                components.append(.token(String(trimmed[i...k]), .preprocessing))
                                i = trimmed.index(after: k)
                                continue
                            }
                        }
                    }
                }
                components.append(.token(String(char), .keyword))
                i = trimmed.index(after: i)
                continue
            }

            if char == ")" {
                components.append(.token(String(char), .keyword))
                i = trimmed.index(after: i)
                continue
            }

            // Quantifiers
            if "?*+".contains(char) {
                components.append(.token(String(char), .call))
                i = trimmed.index(after: i)
                continue
            }

            // Quantifier ranges
            if char == "{" {
                var j = trimmed.index(after: i)
                var foundClose = false
                while j < trimmed.endIndex {
                    if trimmed[j] == "}" {
                        foundClose = true
                        components.append(.token(String(trimmed[i...j]), .call))
                        i = trimmed.index(after: j)
                        break
                    }
                    if !trimmed[j].isNumber && trimmed[j] != "," {
                        break
                    }
                    j = trimmed.index(after: j)
                }
                if !foundClose {
                    components.append(.plainText(String(char)))
                    i = trimmed.index(after: i)
                }
                continue
            }

            // Anchors
            if "^$".contains(char) {
                components.append(.token(String(char), .property))
                i = trimmed.index(after: i)
                continue
            }

            // OR operator
            if char == "|" {
                components.append(.token(String(char), .keyword))
                i = trimmed.index(after: i)
                continue
            }

            // Dot (any character)
            if char == "." {
                components.append(.token(String(char), .keyword))
                i = trimmed.index(after: i)
                continue
            }

            // Comments in regex (if supported)
            if char == "#" {
                components.append(.token(String(trimmed[i...]), .comment))
                break
            }

            // Default - literal character
            components.append(.plainText(String(char)))
            i = trimmed.index(after: i)
        }

        return components
    }
}