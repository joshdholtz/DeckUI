//
//  Title.swift
//  DeckUI
//
//  Created by Josh Holtz on 8/30/22.
//

import SwiftUI

public struct Title: ContentItem {
    enum Style {
        case title, subtitle, body
        
        var font: Font {
            switch self {
            case .title:
                return Font.system(size: 60, weight: .bold, design: .default)
            case .subtitle:
                return Font.system(size: 40, weight: .light, design: .default)
            case .body:
                return Font.system(size: 30, weight: .regular, design: .default)
            }
        }
    }
    
    public let id = UUID()
    let title: String
    let subtitle: String?
    
    public init(_ title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }
    
    @ViewBuilder
    public var view: AnyView {
        AnyView(
            // TODO: Fix hardcoding of alignment
            VStack(alignment: .leading, spacing: 0) {
                Text(self.title)
                    .font(Font.system(size: 60, weight: .bold, design: .default))
                
                if let subtitle = self.subtitle {
                    Text(subtitle)
                        .font(Font.system(size: 35, weight: .light, design: .default))
                        .italic()
                }
            }.padding(.bottom, 20)
        )
    }
}
