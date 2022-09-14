//
//  NoGrammar.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-11.
//

import Foundation
import Splash

struct NoGammar: Grammar {
    var delimiters: CharacterSet = CharacterSet()
    
    var syntaxRules = [Splash.SyntaxRule]()
}
