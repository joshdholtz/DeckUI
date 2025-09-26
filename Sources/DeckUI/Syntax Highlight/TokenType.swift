//
//  TokenType.swift
//  DeckUI
//
//  Created by Claude on 2025-09-26.
//

import Foundation

public enum TokenType: Hashable {
    case keyword
    case string
    case type
    case call
    case number
    case comment
    case property
    case dotAccess
    case preprocessing
    case plainText
    case custom(String)
}