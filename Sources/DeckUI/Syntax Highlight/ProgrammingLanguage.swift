//
//  ProgrammingLanguage.swift
//  DeckUI
//
//  Created by Yonatan Mittlefehldt on 2022-09-09.
//

import Foundation

public enum ProgrammingLanguage: String {
    case none
    case swift
    case objc
    case ruby
    case bash
    case sql
    case html
    case regex

    var name: String {
        rawValue
    }
}

