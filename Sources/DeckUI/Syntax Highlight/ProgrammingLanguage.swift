//
//  ProgrammingLanguage.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import Splash

public enum ProgrammingLanguage: String {
    case none
    case swift
    case objc
    case ruby
    case bash
    
    var name: String {
        rawValue
    }
    
    var grammar: Grammar {
        switch self {
        case .swift:
            return SwiftGrammar()
        case .objc:
            return NoGammar()
        case .ruby:
            return NoGammar()
        case .bash:
            return NoGammar()
        case .none:
            return NoGammar()
        }
    }
}

