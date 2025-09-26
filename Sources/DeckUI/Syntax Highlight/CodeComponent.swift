//
//  CodeComponent.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import Foundation

enum CodeComponent: Equatable, Hashable {
    case token(String, TokenType)
    case plainText(String)
    case whitespace(String)

    var isWhitespace: Bool {
        switch self {
        case .whitespace(_):
            return true
        default:
            return false
        }
    }
}
