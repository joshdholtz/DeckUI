//
//  ProgrammingLanguage.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import Splash
import SplashPython

public enum ProgrammingLanguage: String {
    case none
    case python
    case swift
    
    var name: String {
        rawValue
    }
    
    var grammar: Grammar {
        switch self {
        case .python:
            return PythonGrammar()
        case .swift:
            return SwiftGrammar()
        case .none:
            return NoGammar()
        }
    }
}

