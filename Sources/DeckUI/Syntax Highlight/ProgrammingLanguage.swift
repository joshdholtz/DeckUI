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
    
    var name: String {
        rawValue
    }
    
    var grammar: Grammar {
        switch self {
        case .swift:
            return SwiftGrammar()
        case .none:
            return NoGammar()
        }
    }
}

